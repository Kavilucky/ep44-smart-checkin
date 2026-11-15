-- Схема для бесконтактного заселения (пример). Выполняется один раз при первом запуске PostgreSQL.
CREATE TABLE IF NOT EXISTS guests (
  chat_id      BIGINT PRIMARY KEY,                 -- идентификатор чата Telegram
  step         SMALLINT NOT NULL DEFAULT 0,        -- 0 ждём фото паспорта, 1 ждём селфи, 2 ждём согласие, 3 готово
  checkin_at   TIMESTAMPTZ,                        -- заезд (заполняет хозяин по брони)
  checkout_at  TIMESTAMPTZ,                        -- выезд: пин-код действует до этого времени
  passport_file TEXT,                              -- путь к скану на зашифрованном томе
  selfie_file  TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS consents (
  id            BIGSERIAL PRIMARY KEY,
  chat_id       BIGINT NOT NULL REFERENCES guests(chat_id),
  offer_version TEXT NOT NULL,                     -- версия оферты, с которой согласился гость
  accepted_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS access_log (
  id           BIGSERIAL PRIMARY KEY,
  chat_id      BIGINT NOT NULL REFERENCES guests(chat_id),
  valid_until  TIMESTAMPTZ NOT NULL,               -- когда пин-код перестаёт действовать
  lock_status  TEXT,                               -- ответ API замка (без самого пин-кода)
  issued_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
