#include "UserManager.h"
#include <QCryptographicHash>
#include <QDebug>

UserManager::UserManager(QObject *parent)
    : QObject(parent)
    , _isLoggedIn(false)
    , _currentUser("")
    , _currentRole("")
{
    // Set up user data path
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(appDataPath);
    _userDataPath = appDataPath + "/users.json";
    
    loadUsers();
    createDefaultUsers(); // Create default users if they don't exist
}

bool UserManager::authenticate(const QString& username, const QString& password)
{
    if (_users.contains(username)) {
        QJsonObject user = _users[username].toObject();
        QString storedPasswordHash = user["password"].toString();
        QString role = user["role"].toString();
        
        if (storedPasswordHash == hashPassword(password)) {
            _isLoggedIn = true;
            _currentUser = username;
            _currentRole = role;
            
            emit loginStateChanged();
            emit currentUserChanged();
            emit currentRoleChanged();
            
            qDebug() << "User authenticated:" << username << "Role:" << role;
            return true;
        }
    }
    
    emit authenticationFailed();
    return false;
}

void UserManager::logout()
{
    _isLoggedIn = false;
    _currentUser = "";
    _currentRole = "";
    
    emit loginStateChanged();
    emit currentUserChanged();
    emit currentRoleChanged();
}

bool UserManager::hasPermission(const QString& feature) const
{
    if (!_isLoggedIn) return false;
    
    // Define permissions based on roles
    if (_currentRole == "Admin") {
        return true; // Admin has access to everything
    } else if (_currentRole == "Engineer") {
        return true; // Engineers have access to most features
    } else if (_currentRole == "Operator") {
        // Operators have restricted access
        QStringList restrictedFeatures = {
            "firmware_upgrade",
            "parameter_editor", 
            "system_settings"
        };
        return !restrictedFeatures.contains(feature);
    }
    
    return false;
}

void UserManager::createDefaultUsers()
{
    // Create default users if they don't exist
    if (!_users.contains("operator")) {
        QJsonObject operatorUser;
        operatorUser["password"] = hashPassword("operator123");
        operatorUser["role"] = "Operator";
        _users["operator"] = operatorUser;
    }
    
    if (!_users.contains("engineer")) {
        QJsonObject engineerUser;
        engineerUser["password"] = hashPassword("engineer123");
        engineerUser["role"] = "Engineer";
        _users["engineer"] = engineerUser;
    }
    
    if (!_users.contains("admin")) {
        QJsonObject adminUser;
        adminUser["password"] = hashPassword("admin123");
        adminUser["role"] = "Admin";
        _users["admin"] = adminUser;
    }
    
    saveUsers();
}

void UserManager::loadUsers()
{
    QFile file(_userDataPath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        _users = doc.object();
    }
}

void UserManager::saveUsers()
{
    QFile file(_userDataPath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(_users);
        file.write(doc.toJson());
    }
}

QString UserManager::hashPassword(const QString& password) const
{
    return QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex();
}
