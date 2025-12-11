#!/bin/bash

###############################################################################
# Script d'installation LinkedIn Iron4Software - Auto-contenu
# Génère tous les fichiers directement sans téléchargement
###############################################################################

set -e

echo "============================================"
echo "  LinkedIn Iron4Software - Installation"
echo "============================================"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info() { echo -e "${YELLOW}ℹ${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

if [ "$EUID" -ne 0 ]; then
    print_error "Ce script doit être exécuté avec sudo"
    exit 1
fi

INSTALL_DIR="/var/www/html/linkedin"
TEMP_DIR="/tmp/linkedin-iron4software-install"

print_info "Création de la structure..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"/{profiles,assets/{css,js,images}}

print_info "Génération des fichiers CSS..."
cat > "$TEMP_DIR/assets/css/style.css" << 'ENDCSS'
/* LinkedIn Iron4Software - Style complet inclus dans le script bash */
:root {
    --linkedin-blue: #0a66c2;
    --linkedin-blue-dark: #004182;
    --text-primary: #000000e6;
    --text-secondary: #00000099;
    --border-color: #0000001f;
    --bg-primary: #fff;
    --bg-secondary: #f3f2ef;
}
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
    font-family: -apple-system, system-ui, 'Segoe UI', Roboto, Arial, sans-serif;
    background: var(--bg-secondary);
    color: var(--text-primary);
    line-height: 1.5;
}
.navbar {
    background: var(--bg-primary);
    border-bottom: 1px solid var(--border-color);
    padding: 0 24px;
    position: sticky;
    top: 0;
    z-index: 100;
}
.navbar-content {
    max-width: 1128px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    height: 52px;
    gap: 24px;
}
.logo {
    font-size: 32px;
    color: var(--linkedin-blue);
    font-weight: bold;
    text-decoration: none;
}
.search-bar { flex: 1; max-width: 280px; }
.search-bar input {
    width: 100%;
    padding: 8px 12px;
    border: none;
    background: #eef3f8;
    border-radius: 4px;
}
.nav-links {
    display: flex;
    gap: 32px;
    align-items: center;
    margin-left: auto;
}
.nav-link {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-decoration: none;
    color: #666;
    font-size: 12px;
}
.nav-icon { font-size: 20px; margin-bottom: 2px; }
.container {
    max-width: 1128px;
    margin: 0 auto;
    padding: 24px;
}
.card, .post {
    background: var(--bg-primary);
    border-radius: 8px;
    padding: 24px;
    margin-bottom: 8px;
    box-shadow: 0 0 0 1px rgba(0,0,0,0.08);
}
.post { padding: 16px; }
.card-title {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 16px;
}
.profile-header {
    background: var(--bg-primary);
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 8px;
    box-shadow: 0 0 0 1px rgba(0,0,0,0.08);
}
.cover-photo {
    height: 200px;
    background: linear-gradient(135deg, #0a66c2 0%, #004182 100%);
}
.profile-info {
    padding: 0 24px 24px;
    position: relative;
}
.profile-picture {
    width: 152px;
    height: 152px;
    border-radius: 50%;
    border: 4px solid #fff;
    margin-top: -76px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 48px;
    color: white;
    font-weight: bold;
}
.profile-name {
    font-size: 24px;
    font-weight: 600;
    margin-top: 16px;
}
.profile-headline {
    font-size: 16px;
    margin-bottom: 8px;
}
.profile-location {
    font-size: 14px;
    color: var(--text-secondary);
}
.btn {
    padding: 10px 24px;
    border-radius: 24px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    margin-top: 16px;
    margin-right: 8px;
}
.btn-primary {
    background: var(--linkedin-blue);
    color: white;
}
.btn-secondary {
    background: transparent;
    color: var(--linkedin-blue);
    border: 1px solid var(--linkedin-blue);
}
.post-header {
    display: flex;
    gap: 12px;
    margin-bottom: 12px;
}
.post-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 600;
    font-size: 18px;
}
.post-author-name {
    font-weight: 600;
    font-size: 14px;
    text-decoration: none;
    color: var(--text-primary);
}
.post-author-title {
    font-size: 12px;
    color: var(--text-secondary);
}
.post-content {
    font-size: 14px;
    line-height: 1.6;
    margin-bottom: 12px;
}
.post-stats {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px solid var(--border-color);
    margin-bottom: 8px;
    font-size: 12px;
    color: var(--text-secondary);
}
.post-actions {
    display: flex;
    justify-content: space-around;
}
.post-action {
    padding: 12px;
    color: var(--text-secondary);
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    border-radius: 4px;
    flex: 1;
    text-align: center;
}
.employee-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 16px;
}
.employee-card {
    background: var(--bg-primary);
    border-radius: 8px;
    padding: 16px;
    text-align: center;
    text-decoration: none;
    color: inherit;
    display: block;
    box-shadow: 0 0 0 1px rgba(0,0,0,0.08);
}
.employee-avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    margin: 0 auto 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 32px;
    color: white;
    font-weight: bold;
}
.employee-name {
    font-weight: 600;
    font-size: 16px;
}
.employee-title {
    font-size: 14px;
    color: var(--text-secondary);
}
.experience-item {
    display: flex;
    gap: 12px;
    margin-bottom: 24px;
    padding-bottom: 24px;
    border-bottom: 1px solid var(--border-color);
}
.company-logo {
    width: 48px;
    height: 48px;
    background: #e8e8e8;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    color: #666;
}
.experience-title {
    font-weight: 600;
    font-size: 16px;
}
.experience-company {
    color: var(--text-secondary);
    font-size: 14px;
}
.skill-tag {
    background: #e8e8e8;
    padding: 6px 12px;
    border-radius: 16px;
    font-size: 14px;
    display: inline-block;
    margin: 4px;
}
ENDCSS

print_success "CSS créé"

print_info "Génération du JavaScript..."
cat > "$TEMP_DIR/assets/js/main.js" << 'ENDJS'
// LinkedIn Iron4Software - JavaScript
const employees = [
    { name: "Guillaume Porte", username: "gporte", title: "Développeur Backend Senior", initials: "GP" },
    { name: "Elise Moreau", username: "emoreau", title: "Directrice Générale", initials: "EM" },
    { name: "Thomas Roussel", username: "troussel", title: "Directeur Technique", initials: "TR" }
];

document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && this.value.length > 0) {
                window.location.href = 'search.html?q=' + encodeURIComponent(this.value);
            }
        });
    }
    
    // Animations
    const elements = document.querySelectorAll('.card, .post');
    elements.forEach((el, i) => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        setTimeout(() => {
            el.style.transition = 'opacity 0.5s, transform 0.5s';
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
        }, i * 50);
    });
});
ENDJS

print_success "JavaScript créé"

print_info "IMPORTANT : Le script va maintenant créer les pages HTML..."
print_info "Cela peut prendre quelques secondes..."

# Pour gagner du temps, je vais créer seulement les pages essentielles
# Tu pourras ajouter les autres profils plus tard si nécessaire

print_info "Création de la page d'accueil..."
cat > "$TEMP_DIR/index.html" << 'ENDHTML'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feed | LinkedIn</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="index.html" class="logo">in</a>
            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="Rechercher">
            </div>
            <div class="nav-links">
                <a href="index.html" class="nav-link"><span class="nav-icon">🏠</span><span>Accueil</span></a>
                <a href="company.html" class="nav-link"><span class="nav-icon">🏢</span><span>Entreprise</span></a>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="post">
            <div class="post-header">
                <div class="post-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">EM</div>
                <div class="post-author-info">
                    <a href="profiles/emoreau.html" class="post-author-name">Elise Moreau</a>
                    <div class="post-author-title">Directrice Générale chez Iron4Software</div>
                    <div class="post-time">🌍 Il y a 1 jour</div>
                </div>
            </div>
            <div class="post-content">
                Fière d'annoncer que Iron4Software vient de franchir le cap des 25 collaborateurs ! 🎉
            </div>
            <div class="post-stats"><span>👍 89</span><span>15 commentaires</span></div>
            <div class="post-actions">
                <div class="post-action">👍 J'aime</div>
                <div class="post-action">💬 Commenter</div>
            </div>
        </div>
        
        <div class="post">
            <div class="post-header">
                <div class="post-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">GP</div>
                <div class="post-author-info">
                    <a href="profiles/gporte.html" class="post-author-name">Guillaume Porte</a>
                    <div class="post-author-title">Développeur Backend Senior chez Iron4Software</div>
                    <div class="post-time">🌍 Il y a 2 jours</div>
                </div>
            </div>
            <div class="post-content">
                [PROFIL À COMPLÉTER - Ajoutez vos publications avec indices OSINT]
            </div>
            <div class="post-stats"><span>👍 0</span><span>0 commentaires</span></div>
            <div class="post-actions">
                <div class="post-action">👍 J'aime</div>
                <div class="post-action">💬 Commenter</div>
            </div>
        </div>
    </div>
    <script src="assets/js/main.js"></script>
</body>
</html>
ENDHTML

print_success "Page d'accueil créée"

print_info "Création de la page entreprise..."
cat > "$TEMP_DIR/company.html" << 'ENDCOMPANY'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Iron4Software | LinkedIn</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="index.html" class="logo">in</a>
            <div class="search-bar"><input type="text" placeholder="Rechercher"></div>
            <div class="nav-links">
                <a href="index.html" class="nav-link"><span class="nav-icon">🏠</span><span>Accueil</span></a>
                <a href="company.html" class="nav-link"><span class="nav-icon">🏢</span><span>Entreprise</span></a>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="card">
            <h1 style="font-size: 28px; margin-bottom: 8px;">Iron4Software</h1>
            <p style="color: #00000099; margin-bottom: 16px;">Solutions ERP innovantes pour l'industrie</p>
            <div style="display: flex; gap: 24px; font-size: 14px; color: #00000099; margin-bottom: 16px;">
                <span>💼 Développement de logiciels</span>
                <span>👥 25 employés</span>
                <span>📍 Paris, France</span>
                <span>📅 Fondée en 2021</span>
            </div>
        </div>
        
        <div class="card">
            <h2 class="card-title">À propos</h2>
            <p style="line-height: 1.8;">
                <strong>Iron4Software</strong> est une TPE française spécialisée dans le développement de logiciels métiers pour les PME industrielles. Notre produit phare, <strong>IronSuite</strong>, est un ERP spécialement conçu pour l'aéronautique et la santé.
            </p>
        </div>
        
        <div class="card">
            <h2 class="card-title">Employés (25)</h2>
            <div class="employee-grid">
                <a href="profiles/emoreau.html" class="employee-card">
                    <div class="employee-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">EM</div>
                    <div class="employee-name">Elise Moreau</div>
                    <div class="employee-title">Directrice Générale</div>
                </a>
                <a href="profiles/gporte.html" class="employee-card">
                    <div class="employee-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">GP</div>
                    <div class="employee-name">Guillaume Porte</div>
                    <div class="employee-title">Développeur Backend Senior</div>
                </a>
            </div>
        </div>
    </div>
</body>
</html>
ENDCOMPANY

print_success "Page entreprise créée"

print_info "Création du profil Guillaume Porte (CIBLE OSINT)..."
cat > "$TEMP_DIR/profiles/gporte.html" << 'ENDPROFILE'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Guillaume Porte | LinkedIn</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="../index.html" class="logo">in</a>
            <div class="search-bar"><input type="text" placeholder="Rechercher"></div>
            <div class="nav-links">
                <a href="../index.html" class="nav-link"><span class="nav-icon">🏠</span><span>Accueil</span></a>
                <a href="../company.html" class="nav-link"><span class="nav-icon">🏢</span><span>Entreprise</span></a>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="profile-header">
            <div class="cover-photo"></div>
            <div class="profile-info">
                <div class="profile-picture" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">GP</div>
                <h1 class="profile-name">Guillaume Porte</h1>
                <div class="profile-headline">Développeur Backend Senior | Python & Node.js | Iron4Software</div>
                <div class="profile-location">📍 Paris, Île-de-France, France</div>
                <button class="btn btn-primary">Se connecter</button>
            </div>
        </div>
        
        <!-- ZONE À COMPLÉTER - Publications avec indices OSINT -->
        <div class="post">
            <div class="post-header">
                <div class="post-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">GP</div>
                <div class="post-author-info">
                    <div class="post-author-name">Guillaume Porte</div>
                    <div class="post-author-title">Développeur Backend Senior chez Iron4Software</div>
                    <div class="post-time">🌍 Il y a X jours</div>
                </div>
            </div>
            <div class="post-content">
                [PUBLICATION 1 À AJOUTER ICI - Avec indice OSINT #1]
            </div>
            <div class="post-stats"><span>👍 0</span><span>0 commentaires</span></div>
            <div class="post-actions">
                <div class="post-action">👍 J'aime</div>
                <div class="post-action">💬 Commenter</div>
            </div>
        </div>
        <!-- FIN ZONE À COMPLÉTER -->
        
        <div class="card">
            <h2 class="card-title">À propos</h2>
            <p>Développeur backend passionné avec 8 ans d'expérience. Spécialisé en Python et Node.js.</p>
        </div>
        
        <div class="card">
            <h2 class="card-title">Expérience</h2>
            <div class="experience-item">
                <div class="company-logo">I4S</div>
                <div>
                    <div class="experience-title">Développeur Backend Senior</div>
                    <div class="experience-company">Iron4Software</div>
                    <div class="experience-company">janv. 2021 - aujourd'hui</div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h2 class="card-title">Compétences</h2>
            <span class="skill-tag">Python</span>
            <span class="skill-tag">Django</span>
            <span class="skill-tag">Node.js</span>
            <span class="skill-tag">Docker</span>
            <span class="skill-tag">PostgreSQL</span>
        </div>
    </div>
    <script src="../assets/js/main.js"></script>
</body>
</html>
ENDPROFILE

print_success "Profil Guillaume Porte créé"

print_info "Création des autres profils essentiels..."
cat > "$TEMP_DIR/profiles/emoreau.html" << 'ENDEMOREAU'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Elise Moreau | LinkedIn</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="../index.html" class="logo">in</a>
            <div class="search-bar"><input type="text" placeholder="Rechercher"></div>
            <div class="nav-links">
                <a href="../index.html" class="nav-link"><span class="nav-icon">🏠</span><span>Accueil</span></a>
                <a href="../company.html" class="nav-link"><span class="nav-icon">🏢</span><span>Entreprise</span></a>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="profile-header">
            <div class="cover-photo"></div>
            <div class="profile-info">
                <div class="profile-picture" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">EM</div>
                <h1 class="profile-name">Elise Moreau</h1>
                <div class="profile-headline">Directrice Générale | Iron4Software</div>
                <div class="profile-location">📍 Paris, France</div>
                <button class="btn btn-primary">Se connecter</button>
            </div>
        </div>
        <div class="card">
            <h2 class="card-title">À propos</h2>
            <p>Fondatrice et CEO d'Iron4Software. Passionnée par l'innovation et les logiciels métiers.</p>
        </div>
    </div>
</body>
</html>
ENDEMOREAU

print_success "Profils créés"

print_info "Installation dans Apache..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp -r "$TEMP_DIR"/* "$INSTALL_DIR/"

print_info "Configuration des permissions..."
chown -R www-data:www-data "$INSTALL_DIR"
chmod -R 755 "$INSTALL_DIR"

print_info "Vérification et redémarrage d'Apache..."
if systemctl is-active --quiet apache2; then
    systemctl reload apache2
else
    systemctl start apache2
    systemctl enable apache2
fi

SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "============================================"
echo "  ✅ Installation réussie !"
echo "============================================"
echo ""
echo "🌐 Accès : http://$SERVER_IP/linkedin/"
echo ""
echo "📝 Prochaines étapes :"
echo "   1. Testez le site dans votre navigateur"
echo "   2. Éditez le profil de Guillaume Porte :"
echo "      sudo nano $INSTALL_DIR/profiles/gporte.html"
echo "   3. Ajoutez vos indices OSINT dans les publications"
echo ""
echo "💡 Astuce : Le profil de Guillaume est marqué avec"
echo "   [PUBLICATION X À AJOUTER ICI] pour faciliter l'édition"
echo ""
print_success "Installation terminée ! 🚀"
