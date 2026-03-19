CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'artist' CHECK(role IN ('artist', 'admin', 'collector')),
  plan TEXT NOT NULL DEFAULT 'starter' CHECK(plan IN ('starter', 'pro', 'galerie')),
  avatar_url TEXT,
  bio TEXT,
  location TEXT,
  website TEXT,
  instagram TEXT,
  -- Champs générés par l'IA
  ai_bio TEXT,
  ai_statement TEXT,
  ai_style_tags TEXT, -- JSON array stocké en texte: ["Abstrait","Minimaliste","Contemporain"]
  ai_tokens_used INTEGER DEFAULT 0,
  ai_generated_at TEXT,
  saved_themes TEXT, -- JSON array de thèmes sauvegardés
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS artworks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  artist_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  medium TEXT NOT NULL,
  style TEXT NOT NULL,
  description TEXT,
  price REAL NOT NULL,
  available INTEGER NOT NULL DEFAULT 1 CHECK(available IN (0, 1)),
  image_url TEXT,
  year INTEGER,
  dimensions TEXT,
  featured INTEGER DEFAULT 0 CHECK(featured IN (0, 1)),
  view_count INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS collections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  artist_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS artwork_collections (
  artwork_id INTEGER REFERENCES artworks(id) ON DELETE CASCADE,
  collection_id INTEGER REFERENCES collections(id) ON DELETE CASCADE,
  PRIMARY KEY (artwork_id, collection_id)
);

-- Index pour les recherches fréquentes
CREATE INDEX IF NOT EXISTS idx_artworks_artist ON artworks(artist_id);
CREATE INDEX IF NOT EXISTS idx_artworks_medium ON artworks(medium);
CREATE INDEX IF NOT EXISTS idx_artworks_style ON artworks(style);
CREATE INDEX IF NOT EXISTS idx_artworks_available ON artworks(available);
CREATE INDEX IF NOT EXISTS idx_artworks_price ON artworks(price);
CREATE INDEX IF NOT EXISTS idx_artworks_featured ON artworks(featured);

CREATE TABLE IF NOT EXISTS password_resets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token TEXT NOT NULL UNIQUE,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_password_resets_token ON password_resets(token);
