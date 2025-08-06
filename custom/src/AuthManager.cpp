// #include "AuthManager.h"
// #include <QTimer>
// #include <QDebug>

// const QString AuthManager::VALID_USERNAME = "admin";
// const QString AuthManager::VALID_PASSWORD = "password";

// AuthManager& AuthManager::instance()
// {
//     static AuthManager _instance;
//     return _instance;
// }

// AuthManager::AuthManager(QObject* parent)
//     : QObject(parent)
// {
// }

// void AuthManager::setShowSplash(bool show)
// {
//     if (m_showSplash != show) {
//         m_showSplash = show;
//         emit showSplashChanged();
//     }
// }

// void AuthManager::setShowLogin(bool show)
// {
//     if (m_showLogin != show) {
//         m_showLogin = show;
//         emit showLoginChanged();
//     }
// }

// void AuthManager::startAuthSequence()
// {
//     qDebug() << "Starting authentication sequence...";

//     // Show splash for 3 seconds, then show login
//     QTimer::singleShot(3000, [this]() {
//         setShowSplash(false);
//         setShowLogin(true);
//         qDebug() << "Splash finished, showing login...";
//     });
// }

// bool AuthManager::authenticate(const QString& username, const QString& password)
// {
//     qDebug() << "Authentication attempt for user:" << username;

//     if (username == VALID_USERNAME && password == VALID_PASSWORD) {
//         m_authenticated = true;
//         setShowLogin(false);
//         emit authenticationChanged();
//         qDebug() << "Authentication successful!";
//         return true;
//     } else {
//         qDebug() << "Authentication failed - invalid credentials";
//         return false;
//     }
// }

#include "AuthManager.h"
#include <QDebug>
#include <QTimer>

// Define valid users with their roles
const QList<AuthManager::UserCredentials> AuthManager::VALID_USERS = {
    {"operator", "op123", UserRole::Operator},
    {"engineer", "eng456", UserRole::Engineer}
};

AuthManager& AuthManager::instance()
{
    static AuthManager _instance;
    return _instance;
}

AuthManager::AuthManager(QObject* parent)
    : QObject(parent)
{
}

void AuthManager::setShowSplash(bool show)
{
    if (m_showSplash != show) {
        m_showSplash = show;
        emit showSplashChanged();
    }
}

void AuthManager::setShowLogin(bool show)
{
    if (m_showLogin != show) {
        m_showLogin = show;
        emit showLoginChanged();
    }
}

void AuthManager::startAuthSequence()
{
    qDebug() << "Starting authentication sequence...";
    // Show splash for 3 seconds, then show login
    QTimer::singleShot(3000, [this]() {
        setShowSplash(false);
        setShowLogin(true);
        qDebug() << "Splash finished, showing login...";
    });
}

bool AuthManager::authenticate(const QString& username, const QString& password)
{
    qDebug() << "Authentication attempt for user:" << username;
    
    for (const auto& user : VALID_USERS) {
        if (username == user.username && password == user.password) {
            m_authenticated = true;
            m_currentRole = user.role;
            m_currentUsername = username;
            setShowLogin(false);
            emit authenticationChanged();
            emit userRoleChanged();
            
            QString roleStr = (user.role == UserRole::Engineer) ? "Engineer" : "Operator";
            qDebug() << "Authentication successful! User:" << username << "Role:" << roleStr;
            return true;
        }
    }
    
    qDebug() << "Authentication failed - invalid credentials";
    return false;
}

bool AuthManager::hasEngineerAccess() const
{
    return m_authenticated && (m_currentRole == UserRole::Engineer);
}
void AuthManager::logout()
{
    qDebug() << "User logging out...";
    m_authenticated = false;
    m_currentRole = UserRole::None;
    m_currentUsername.clear();
    setShowLogin(true);
    emit authenticationChanged();
    emit userRoleChanged();
    emit clearLoginFields();
    qDebug() << "User logged out - returning to login screen";
}

