# Good Bank – Barbados Youth Digital Wallet 📲💙

**STRATEGIC UPDATE (Jan 2025):** This project has pivoted from building from scratch to **customizing the proven Yoma open-source platform** for Barbados-specific needs.

Digital public infrastructure prototype rewarding Barbadian youth for **verified learning** (NTI courses) and **community service** (Give Back Barbados), powered by **Barbados National ID** smart card authentication.

---

## 🎯 Project Status

### **Current Achievement**
✅ **Yoma Platform Operational** - Full development environment running locally  
✅ **All Services Deployed** - PostgreSQL, Keycloak Auth, .NET 9 API, NextJS frontend  
✅ **Strategic Foundation** - Leveraging battle-tested South African youth engagement platform  

### **Next Phase**
🔧 **Barbados Customization** - Integrate national ID smart card authentication  
🎨 **UI/Brand Adaptation** - Barbadian visual identity and local content  
💰 **Sand Dollar Integration** - Central bank digital currency rewards  

---

## 🏗️ Architecture Overview

### **Technology Stack (Yoma-Based)**
- **Frontend**: NextJS 15 (TypeScript) + PWA capabilities
- **Backend**: .NET 9 Web API with Entity Framework
- **Database**: PostgreSQL 17 with automated migrations  
- **Authentication**: Keycloak + **Barbados National ID** (planned)
- **Cache**: Valkey (Redis alternative)
- **Infrastructure**: Docker Compose + Kubernetes Helm charts
- **Self-Sovereign Identity**: CloudAPI SSI Stack (Phase 2)

### **Key Services**
- **📱 Web Application**: http://localhost:3000
- **🔐 Keycloak Auth**: http://localhost:8080  
- **🌐 Yoma API**: http://localhost:5000
- **📊 Admin Dashboard**: Built-in opportunity & user management

---

## 🚀 Quick Start

### **Prerequisites**
- Docker Desktop (running)
- .NET 9 SDK  
- Node.js 20 + Yarn
- Git

### **Development Setup**
```bash
# 1. Clone the repositories
git clone https://github.com/didx-xyz/yoma.git yoma-platform
cd yoma-platform

# 2. Start backend services
cd src/api
docker-compose up -d

# 3. Start frontend (new terminal)
cd ../web
yarn install --ignore-engines
yarn dev

# 4. Access the platform
# Frontend: http://localhost:3000
# API: http://localhost:5000  
# Keycloak: http://localhost:8080
```

### **Test Accounts**
- **Admin**: admin@yoma.world / password123
- **Youth User**: youth@example.com / password123

---

## 📋 Strategic Rationale

### **Why Yoma Platform?**
1. **Proven at Scale** - Successfully deployed in South Africa
2. **Battle-Tested** - Multi-tenant, enterprise-grade architecture  
3. **Feature Complete** - Opportunities, verification, marketplace, SSI-ready
4. **Open Source** - GPL-3.0 license, full customization rights
5. **Time-to-Market** - 3-5 days vs 6+ weeks building from scratch

### **Barbados Customization Plan**
- **🆔 National ID Integration** - Replace password auth with smart card
- **💰 Sand Dollar Rewards** - CBDC integration for token redemption  
- **🏛️ Local Content** - NTI courses, Give Back Barbados partnerships
- **🎨 Branding** - Barbadian visual identity and terminology
- **📱 Mobile Apps** - Flutter apps connecting to Yoma API

---

## 📚 Documentation

### **Development**
- [Yoma Architecture Docs](https://docs.yoma.world/technology/architecture)
- [Original Flutter Prototype](./mobile_app/) - Preserved for UX patterns
- [Updated Roadmap](./docs/roadmap.md) - Yoma customization phases

### **Business Context**  
- [Architecture Diagram](./diagrams/) - Original system design
- [Project Pitch](./pitch_decks/) - Business case and vision

---

## 🤝 Team & Collaboration

### **Current Team**
- **Project Lead**: Strategic oversight and requirements
- **Yoma Consultant** (In-house): Platform expertise and guidance
- **AI Development Partner**: Implementation and customization

### **Consultant Leverage Strategy**
With a Yoma lead coordinator on-site, we have direct access to:
- Platform architecture decisions and lessons learned
- Customization best practices and shortcuts  
- SSI integration roadmap and technical guidance
- Community connections and partnership opportunities

---

## 📅 Next Session Priorities

### **Immediate Tasks (Tomorrow)**
1. **🔗 Test Platform Integration** - Verify all services communicating
2. **🎨 UI Customization** - Barbadian branding and terminology  
3. **📋 Content Setup** - Load NTI courses and local opportunities
4. **🆔 National ID Research** - Smart card integration architecture

### **This Week Goals**
- ✅ Platform operational and customized
- ✅ Test users completing local opportunities  
- ✅ Barbadian branding and content
- ✅ National ID integration plan finalized

---

## 🔧 Troubleshooting

### **Common Issues**
- **Docker not running**: Start Docker Desktop and wait 2-3 minutes
- **Port conflicts**: Stop other services on ports 3000, 5000, 8080
- **Node version**: Use Node 20.x (yarn install --ignore-engines if needed)
- **Database issues**: `docker-compose down && docker-compose up -d`

### **Platform Health Check**
```bash
# Verify all services
docker-compose ps

# Test API
curl http://localhost:5000/api/v3/lookup/skill

# Test Auth  
curl http://localhost:8080/realms/yoma/.well-known/openid_configuration
```

---

**🎉 Ready to build the future of youth engagement in Barbados!**

