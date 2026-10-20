-- Schéma de base de données pour l'invitation de mariage

-- Table pour la configuration générale (textes, dates, etc.)
CREATE TABLE IF NOT EXISTS wedding_config (
    key TEXT PRIMARY KEY,
    value JSONB
);

-- Table pour les invités et RSVP
CREATE TABLE IF NOT EXISTS guests (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    nb_persons INTEGER DEFAULT 1,
    rsvp_status BOOLEAN, -- true: présent, false: absent, null: en attente
    drinks JSONB DEFAULT '[]',
    gift_choice TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table pour le livre d'or
CREATE TABLE IF NOT EXISTS guestbook (
    id SERIAL PRIMARY KEY,
    guest_name TEXT,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table pour les tables de la salle
CREATE TABLE IF NOT EXISTS wedding_tables (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    capacity INTEGER DEFAULT 8
);

-- Table de liaison Invité <-> Table
CREATE TABLE IF NOT EXISTS table_assignments (
    table_id INTEGER REFERENCES wedding_tables(id) ON DELETE CASCADE,
    guest_id INTEGER REFERENCES guests(id) ON DELETE CASCADE,
    PRIMARY KEY (table_id, guest_id)
);

-- Table pour les réactions sociales
CREATE TABLE IF NOT EXISTS social_reactions (
    type TEXT PRIMARY KEY,
    count INTEGER DEFAULT 0
);

-- Insertion de la configuration par défaut
INSERT INTO wedding_config (key, value) VALUES 
('main', '{
    "title": "Grâce & David",
    "welcome": "ont la joie de vous convier à la célébration de leur union.",
    "date": "2027-02-27T14:00",
    "place": "Salle Les Jardins d’Or, Avenue de la Paix, Kinshasa",
    "wa": "243000000000",
    "rsvpText": "Merci de confirmer votre présence avant le 13 février 2027",
    "drinksText": "Aidez-nous à préparer la fête : choisissez vos boissons préférées.",
    "giftText": "Votre présence est notre plus beau cadeau. Si vous souhaitez nous gâter, voici comment faire.",
    "interText": "Partagez votre enthousiasme avec les autres invités !"
}'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- Insertion des réactions par défaut
INSERT INTO social_reactions (type, count) VALUES 
('❤️', 0), ('🎉', 0), ('🥂', 0), ('😍', 0)
ON CONFLICT (type) DO NOTHING;
