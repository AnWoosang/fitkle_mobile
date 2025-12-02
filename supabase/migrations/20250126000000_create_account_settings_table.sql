-- Create account_settings table
CREATE TABLE IF NOT EXISTS account_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Language setting (based on Country enum - ISO 3166-1 alpha-2 codes)
  language VARCHAR(2) NOT NULL DEFAULT 'KR'
    CHECK (language IN (
      'AF', 'AL', 'DZ', 'AD', 'AO', 'AG', 'AR', 'AM', 'AU', 'AT',
      'AZ', 'BS', 'BH', 'BD', 'BB', 'BY', 'BE', 'BZ', 'BJ', 'BT',
      'BO', 'BA', 'BW', 'BR', 'BN', 'BG', 'BF', 'BI', 'KH', 'CM',
      'CA', 'CV', 'CF', 'TD', 'CL', 'CN', 'CO', 'CD', 'CR', 'HR',
      'CU', 'CY', 'CZ', 'DK', 'DJ', 'DM', 'DO', 'EC', 'EG', 'SV',
      'GQ', 'ER', 'EE', 'SZ', 'ET', 'FJ', 'FI', 'FR', 'GA', 'GM',
      'GE', 'DE', 'GH', 'GR', 'GD', 'GT', 'GN', 'GW', 'GY', 'HT',
      'HN', 'HK', 'HU', 'IS', 'IN', 'ID', 'IR', 'IQ', 'IE', 'IL',
      'IT', 'JM', 'JP', 'JO', 'KZ', 'KE', 'KI', 'KW', 'KG', 'LA',
      'LV', 'LB', 'LS', 'LR', 'LY', 'LI', 'LT', 'LU', 'MG', 'MW',
      'MY', 'MV', 'ML', 'MT', 'MH', 'MR', 'MU', 'MX', 'FM', 'MD',
      'MC', 'MN', 'ME', 'MA', 'MZ', 'MM', 'NA', 'NR', 'NP', 'NL',
      'NZ', 'NI', 'NE', 'NG', 'KP', 'MK', 'NO', 'OM', 'PK', 'PW',
      'PS', 'PA', 'PG', 'PY', 'PE', 'PH', 'PL', 'PT', 'QA', 'RO',
      'RU', 'RW', 'KN', 'LC', 'VC', 'WS', 'SM', 'ST', 'SA', 'SN',
      'RS', 'SC', 'SL', 'SG', 'SK', 'SI', 'SB', 'SO', 'ZA', 'KR',
      'SS', 'ES', 'LK', 'SD', 'SR', 'SE', 'CH', 'SY', 'TW', 'TJ',
      'TZ', 'TH', 'TL', 'TG', 'TO', 'TT', 'TN', 'TR', 'TM', 'TV',
      'UG', 'UA', 'AE', 'GB', 'US', 'UY', 'UZ', 'VU', 'VA', 'VE',
      'VN', 'YE', 'ZM', 'ZW'
    )),

  -- Contact permission setting
  contact_permission VARCHAR(50) NOT NULL DEFAULT 'ANYONE'
    CHECK (contact_permission IN (
      'ANYONE',
      'EVENT_OR_GROUP_MEMBERS',
      'EVENT_MEMBERS_ONLY',
      'GROUP_MEMBERS_ONLY',
      'NONE'
    )),

  -- Notification settings
  email_notifications BOOLEAN NOT NULL DEFAULT true,
  push_notifications BOOLEAN NOT NULL DEFAULT true,
  event_reminders BOOLEAN NOT NULL DEFAULT true,
  group_updates BOOLEAN NOT NULL DEFAULT true,
  newsletter_subscription BOOLEAN NOT NULL DEFAULT false,

  -- UI settings
  timezone VARCHAR(100) NOT NULL DEFAULT 'Asia/Seoul',
  theme VARCHAR(10) NOT NULL DEFAULT 'auto'
    CHECK (theme IN ('light', 'dark', 'auto')),

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Constraints
  UNIQUE(member_id)
);

-- Create index for faster lookups
CREATE INDEX idx_account_settings_member_id ON account_settings(member_id);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_account_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_account_settings_updated_at
  BEFORE UPDATE ON account_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_account_settings_updated_at();

-- Create trigger to auto-create account settings when new member signs up
CREATE OR REPLACE FUNCTION create_default_account_settings()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO account_settings (member_id)
  VALUES (NEW.id)
  ON CONFLICT (member_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_default_account_settings
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION create_default_account_settings();

-- Create trigger to hard delete account settings when member is soft deleted
-- Assuming members table has a deleted_at column for soft delete
CREATE OR REPLACE FUNCTION delete_account_settings_on_member_soft_delete()
RETURNS TRIGGER AS $$
BEGIN
  -- If deleted_at is being set (soft delete)
  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    DELETE FROM account_settings WHERE member_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Note: This trigger should be created on the members table
-- Uncomment and adjust table name if members table exists
-- CREATE TRIGGER trigger_delete_account_settings_on_soft_delete
--   AFTER UPDATE ON members
--   FOR EACH ROW
--   EXECUTE FUNCTION delete_account_settings_on_member_soft_delete();

-- Enable Row Level Security
ALTER TABLE account_settings ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only read their own settings
CREATE POLICY account_settings_select_policy ON account_settings
  FOR SELECT
  USING (auth.uid() = member_id);

-- RLS Policy: Users can only update their own settings
CREATE POLICY account_settings_update_policy ON account_settings
  FOR UPDATE
  USING (auth.uid() = member_id)
  WITH CHECK (auth.uid() = member_id);

-- RLS Policy: Users can insert their own settings (handled by trigger, but kept for explicit control)
CREATE POLICY account_settings_insert_policy ON account_settings
  FOR INSERT
  WITH CHECK (auth.uid() = member_id);

-- RLS Policy: Users cannot delete their own settings (only system can via cascade)
-- No delete policy means users cannot manually delete

-- Add comments for documentation
COMMENT ON TABLE account_settings IS 'User account settings including language, privacy, notifications, and UI preferences';
COMMENT ON COLUMN account_settings.language IS 'User preferred language (ISO 3166-1 alpha-2 country code)';
COMMENT ON COLUMN account_settings.contact_permission IS 'Who can contact this user via chat';
COMMENT ON COLUMN account_settings.email_notifications IS 'Whether user receives email notifications';
COMMENT ON COLUMN account_settings.push_notifications IS 'Whether user receives push notifications';
COMMENT ON COLUMN account_settings.event_reminders IS 'Whether user receives event reminder notifications';
COMMENT ON COLUMN account_settings.group_updates IS 'Whether user receives group update notifications';
COMMENT ON COLUMN account_settings.newsletter_subscription IS 'Whether user is subscribed to newsletter';
COMMENT ON COLUMN account_settings.timezone IS 'User timezone (IANA timezone identifier)';
COMMENT ON COLUMN account_settings.theme IS 'UI theme preference: light, dark, or auto';
