# Supabase Auth Schema Documentation

> Fitkle 프로젝트의 Supabase Auth 스키마 문서입니다.
>
> Project ID: `phxzjlgauwnxmtvpeort`
>
> 생성일: 2025-11-23

---

## 목차

1. [개요](#개요)
2. [auth.users 테이블](#authusers-테이블)
3. [auth.identities 테이블](#authidentities-테이블)
4. [auth.sessions 테이블](#authsessions-테이블)
5. [auth.refresh_tokens 테이블](#authrefresh_tokens-테이블)
6. [auth.mfa_factors 테이블](#authmfa_factors-테이블)
7. [auth.audit_log_entries 테이블](#authaudit_log_entries-테이블)
8. [auth.one_time_tokens 테이블](#authone_time_tokens-테이블)
9. [전체 Auth 테이블 목록](#전체-auth-테이블-목록)

---

## 개요

Supabase Auth는 사용자 인증 및 권한 관리를 위한 스키마입니다. `auth` 스키마에는 사용자 정보, 세션, 토큰, MFA 등 인증 관련 모든 데이터가 저장됩니다.

---

## auth.users 테이블

사용자의 기본 인증 정보를 저장하는 핵심 테이블입니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | 최대 길이 | Nullable | 기본값 | 설명 |
|--------|-------------|-----------|----------|--------|------|
| `id` | uuid | - | **NO** | - | 사용자 고유 ID (PK) |
| `instance_id` | uuid | - | YES | - | Supabase 인스턴스 ID |
| `aud` | varchar | 255 | YES | - | Audience (일반적으로 'authenticated') |
| `role` | varchar | 255 | YES | - | 사용자 역할 (일반적으로 'authenticated') |
| `email` | varchar | 255 | YES | - | 이메일 주소 |
| `encrypted_password` | varchar | 255 | YES | - | bcrypt로 암호화된 비밀번호 |
| `email_confirmed_at` | timestamptz | - | YES | - | 이메일 확인 일시 |
| `invited_at` | timestamptz | - | YES | - | 초대 일시 |
| `confirmation_token` | varchar | 255 | YES | - | 이메일 확인 토큰 |
| `confirmation_sent_at` | timestamptz | - | YES | - | 확인 메일 발송 일시 |
| `recovery_token` | varchar | 255 | YES | - | 비밀번호 복구 토큰 |
| `recovery_sent_at` | timestamptz | - | YES | - | 복구 메일 발송 일시 |
| `email_change_token_new` | varchar | 255 | YES | - | 새 이메일 변경 토큰 |
| `email_change` | varchar | 255 | YES | - | 변경할 새 이메일 주소 |
| `email_change_sent_at` | timestamptz | - | YES | - | 이메일 변경 메일 발송 일시 |
| `last_sign_in_at` | timestamptz | - | YES | - | 마지막 로그인 일시 |
| `raw_app_meta_data` | jsonb | - | YES | - | 앱 메타데이터 (provider 정보 등) |
| `raw_user_meta_data` | jsonb | - | YES | - | 사용자 메타데이터 |
| `is_super_admin` | boolean | - | YES | - | 슈퍼 관리자 여부 |
| `created_at` | timestamptz | - | YES | - | 생성 일시 |
| `updated_at` | timestamptz | - | YES | - | 수정 일시 |
| `phone` | text | - | YES | NULL | 전화번호 |
| `phone_confirmed_at` | timestamptz | - | YES | - | 전화번호 확인 일시 |
| `phone_change` | text | - | YES | '' | 변경할 전화번호 |
| `phone_change_token` | varchar | 255 | YES | '' | 전화번호 변경 토큰 |
| `phone_change_sent_at` | timestamptz | - | YES | - | 전화번호 변경 SMS 발송 일시 |
| `confirmed_at` | timestamptz | - | YES | - | 계정 확인 일시 (이메일 또는 전화) |
| `email_change_token_current` | varchar | 255 | YES | '' | 현재 이메일 변경 토큰 |
| `email_change_confirm_status` | smallint | - | YES | 0 | 이메일 변경 확인 상태 |
| `banned_until` | timestamptz | - | YES | - | 계정 정지 종료 일시 |
| `reauthentication_token` | varchar | 255 | YES | '' | 재인증 토큰 |
| `reauthentication_sent_at` | timestamptz | - | YES | - | 재인증 메일 발송 일시 |
| `is_sso_user` | boolean | - | **NO** | false | SSO 사용자 여부 (true면 이메일 중복 허용) |
| `deleted_at` | timestamptz | - | YES | - | 소프트 삭제 일시 |
| `is_anonymous` | boolean | - | **NO** | false | 익명 사용자 여부 |

### 제약 조건

| 제약 조건명 | 타입 | 컬럼 |
|-------------|------|------|
| `users_pkey` | PRIMARY KEY | `id` |
| `users_phone_key` | UNIQUE | `phone` |

### 인덱스

| 인덱스명 | 정의 |
|----------|------|
| `users_pkey` | `CREATE UNIQUE INDEX users_pkey ON auth.users USING btree (id)` |
| `users_instance_id_idx` | `CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id)` |
| `users_instance_id_email_idx` | `CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text))` |
| `confirmation_token_idx` | `CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text)` |
| `recovery_token_idx` | `CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text)` |
| `email_change_token_current_idx` | `CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text)` |
| `email_change_token_new_idx` | `CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text)` |
| `reauthentication_token_idx` | `CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text)` |
| `users_email_partial_key` | `CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false)` |
| `users_phone_key` | `CREATE UNIQUE INDEX users_phone_key ON auth.users USING btree (phone)` |
| `users_is_anonymous_idx` | `CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous)` |

### raw_app_meta_data 예시

```json
{
  "provider": "email",
  "providers": ["email"]
}
```

### raw_user_meta_data 예시

```json
{
  "name": "John Doe",
  "avatar_url": "https://example.com/avatar.jpg"
}
```

---

## auth.identities 테이블

OAuth 및 소셜 로그인 제공자와 연결된 사용자 신원 정보를 저장합니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | Nullable | 기본값 | 설명 |
|--------|-------------|----------|--------|------|
| `id` | uuid | **NO** | gen_random_uuid() | 신원 고유 ID (PK) |
| `provider_id` | text | **NO** | - | 제공자별 사용자 ID |
| `user_id` | uuid | **NO** | - | auth.users의 사용자 ID (FK) |
| `identity_data` | jsonb | **NO** | - | 제공자로부터 받은 사용자 데이터 |
| `provider` | text | **NO** | - | 인증 제공자 (email, google, kakao 등) |
| `last_sign_in_at` | timestamptz | YES | - | 마지막 로그인 일시 |
| `created_at` | timestamptz | YES | - | 생성 일시 |
| `updated_at` | timestamptz | YES | - | 수정 일시 |
| `email` | text | YES | - | 제공자로부터 받은 이메일 |

---

## auth.sessions 테이블

활성 사용자 세션 정보를 저장합니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | Nullable | 기본값 | 설명 |
|--------|-------------|----------|--------|------|
| `id` | uuid | **NO** | - | 세션 고유 ID (PK) |
| `user_id` | uuid | **NO** | - | auth.users의 사용자 ID (FK) |
| `created_at` | timestamptz | YES | - | 세션 생성 일시 |
| `updated_at` | timestamptz | YES | - | 세션 수정 일시 |
| `factor_id` | uuid | YES | - | MFA 팩터 ID |
| `aal` | USER-DEFINED | YES | - | Authentication Assurance Level |
| `not_after` | timestamptz | YES | - | 세션 만료 일시 |
| `refreshed_at` | timestamp | YES | - | 마지막 갱신 일시 |
| `user_agent` | text | YES | - | 클라이언트 User-Agent |
| `ip` | inet | YES | - | 클라이언트 IP 주소 |
| `tag` | text | YES | - | 세션 태그 |
| `oauth_client_id` | uuid | YES | - | OAuth 클라이언트 ID |
| `refresh_token_hmac_key` | text | YES | - | 리프레시 토큰 HMAC 키 |
| `refresh_token_counter` | bigint | YES | - | 리프레시 토큰 카운터 |

---

## auth.refresh_tokens 테이블

JWT 리프레시 토큰을 저장합니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | 최대 길이 | Nullable | 기본값 | 설명 |
|--------|-------------|-----------|----------|--------|------|
| `id` | bigint | - | **NO** | nextval(...) | 토큰 고유 ID (PK, 자동 증가) |
| `instance_id` | uuid | - | YES | - | Supabase 인스턴스 ID |
| `token` | varchar | 255 | YES | - | 리프레시 토큰 값 |
| `user_id` | varchar | 255 | YES | - | 사용자 ID |
| `revoked` | boolean | - | YES | - | 토큰 취소 여부 |
| `created_at` | timestamptz | - | YES | - | 토큰 생성 일시 |
| `updated_at` | timestamptz | - | YES | - | 토큰 수정 일시 |
| `parent` | varchar | 255 | YES | - | 부모 토큰 (토큰 체인용) |
| `session_id` | uuid | - | YES | - | 연결된 세션 ID |

---

## auth.mfa_factors 테이블

다중 인증(MFA) 팩터 정보를 저장합니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | Nullable | 기본값 | 설명 |
|--------|-------------|----------|--------|------|
| `id` | uuid | **NO** | - | 팩터 고유 ID (PK) |
| `user_id` | uuid | **NO** | - | auth.users의 사용자 ID (FK) |
| `friendly_name` | text | YES | - | 사용자 지정 팩터 이름 |
| `factor_type` | USER-DEFINED | **NO** | - | 팩터 타입 (totp, phone 등) |
| `status` | USER-DEFINED | **NO** | - | 팩터 상태 (verified, unverified) |
| `created_at` | timestamptz | **NO** | - | 생성 일시 |
| `updated_at` | timestamptz | **NO** | - | 수정 일시 |
| `secret` | text | YES | - | TOTP 비밀 키 |
| `phone` | text | YES | - | MFA 전화번호 |
| `last_challenged_at` | timestamptz | YES | - | 마지막 챌린지 일시 |
| `web_authn_credential` | jsonb | YES | - | WebAuthn 자격 증명 |
| `web_authn_aaguid` | uuid | YES | - | WebAuthn AAGUID |
| `last_webauthn_challenge_data` | jsonb | YES | - | 마지막 WebAuthn 챌린지 데이터 |

---

## auth.audit_log_entries 테이블

인증 관련 감사 로그를 저장합니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | 최대 길이 | Nullable | 기본값 | 설명 |
|--------|-------------|-----------|----------|--------|------|
| `id` | uuid | - | **NO** | - | 로그 고유 ID (PK) |
| `instance_id` | uuid | - | YES | - | Supabase 인스턴스 ID |
| `payload` | json | - | YES | - | 로그 페이로드 (이벤트 상세 정보) |
| `created_at` | timestamptz | - | YES | - | 로그 생성 일시 |
| `ip_address` | varchar | 64 | **NO** | '' | 클라이언트 IP 주소 |

---

## auth.one_time_tokens 테이블

일회용 토큰 (OTP, 이메일 링크 등)을 저장합니다.

### 컬럼 정의

| 컬럼명 | 데이터 타입 | Nullable | 기본값 | 설명 |
|--------|-------------|----------|--------|------|
| `id` | uuid | **NO** | - | 토큰 고유 ID (PK) |
| `user_id` | uuid | **NO** | - | auth.users의 사용자 ID (FK) |
| `token_type` | USER-DEFINED | **NO** | - | 토큰 타입 (confirmation, recovery 등) |
| `token_hash` | text | **NO** | - | 토큰 해시값 |
| `relates_to` | text | **NO** | - | 토큰 관련 대상 (이메일, 전화번호 등) |
| `created_at` | timestamp | **NO** | now() | 토큰 생성 일시 |
| `updated_at` | timestamp | **NO** | now() | 토큰 수정 일시 |

---

## 전체 Auth 테이블 목록

| 테이블명 | 설명 |
|----------|------|
| `auth.users` | 사용자 기본 인증 정보 |
| `auth.identities` | OAuth/소셜 로그인 신원 정보 |
| `auth.sessions` | 활성 세션 정보 |
| `auth.refresh_tokens` | JWT 리프레시 토큰 |
| `auth.mfa_factors` | MFA 팩터 정보 |
| `auth.mfa_challenges` | MFA 챌린지 정보 |
| `auth.mfa_amr_claims` | MFA AMR 클레임 |
| `auth.audit_log_entries` | 인증 감사 로그 |
| `auth.one_time_tokens` | 일회용 토큰 |
| `auth.flow_state` | 인증 플로우 상태 |
| `auth.instances` | Supabase 인스턴스 정보 |
| `auth.sso_providers` | SSO 제공자 정보 |
| `auth.sso_domains` | SSO 도메인 정보 |
| `auth.saml_providers` | SAML 제공자 정보 |
| `auth.saml_relay_states` | SAML 릴레이 상태 |
| `auth.oauth_clients` | OAuth 클라이언트 정보 |
| `auth.oauth_authorizations` | OAuth 인증 정보 |
| `auth.oauth_consents` | OAuth 동의 정보 |
| `auth.schema_migrations` | 스키마 마이그레이션 기록 |

---

## 관련 링크

- [Supabase Auth 공식 문서](https://supabase.com/docs/guides/auth)
- [Supabase Auth API 레퍼런스](https://supabase.com/docs/reference/dart/auth-api)
- [GoTrue (Supabase Auth 서버)](https://github.com/supabase/gotrue)
