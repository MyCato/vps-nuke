# Security Policy

## ⚠️ IMPORTANT SECURITY NOTICE

This software is designed to **IRREVERSIBLY DESTROY** data and systems. By its very nature, it poses extreme security risks if misused.

## Current Version Support

This is the current and actively maintained version of the VPS Nuke script.

## Security Considerations

### 🔴 Critical Risks
- **Data Loss**: This script will permanently destroy all data on target systems
- **System Destruction**: Target systems will become completely unbootable
- **Irreversible Actions**: No recovery possible from local storage after execution

### 🛡️ Safety Measures
- **Root Requirement**: Must be run with sudo/root privileges
- **Confirmation Prompts**: Requires typing "destroy" to proceed (unless `--force`)
- **Device Validation**: Checks that specified devices exist and are block devices
- **Logging**: All operations are logged with timestamps

## Reporting a Vulnerability

### What to Report
- **Security vulnerabilities** in the script logic
- **Privilege escalation** issues
- **Bypass methods** for safety checks
- **Data recovery possibilities** after script execution

### What NOT to Report
- The script "destroying data" (this is intentional behavior)
- Systems becoming "unbootable" (this is the expected outcome)
- "Dangerous functionality" (the entire purpose is data destruction)

### How to Report
1. **DO NOT** create public issues for security vulnerabilities
2. **Create a private security advisory** on GitHub or contact repository owner
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Suggested fix (if available)

### Response Timeline
- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 1 week
- **Fix Development**: Depends on severity
- **Public Disclosure**: After fix is available

## Responsible Use Guidelines

### ✅ Appropriate Use
- **Own systems**: Only use on systems you own and control
- **Authorized destruction**: Ensure you have legal authority
- **Test environments**: Safe for disposable test/dev systems
- **Security compliance**: Meeting data destruction requirements

### ❌ Inappropriate Use
- **Unauthorized systems**: Never use on systems you don't own
- **Production data**: Without proper backups and authorization
- **Malicious purposes**: Any form of cyberattack or sabotage
- **Shared systems**: Systems with other users' data

### 🧪 Testing Recommendations
- **Virtual Machines**: Test in isolated VMs first
- **Containers**: Use disposable containers for testing
- **Separate Networks**: Isolate test systems from production
- **Backup Testing**: Verify backup/restore procedures work

## Legal Compliance

### User Responsibilities
- **Verify ownership** of target systems
- **Check local laws** regarding data destruction
- **Ensure compliance** with organizational policies
- **Document authorization** for destruction activities

### Jurisdictional Considerations
- **Data protection laws** (GDPR, CCPA, etc.)
- **Corporate governance** requirements
- **Industry regulations** (SOX, HIPAA, etc.)
- **Cross-border data** restrictions

## Mitigation Strategies

### Before Use
- [ ] **Verify system ownership** and authorization
- [ ] **Complete data backups** if needed
- [ ] **Test in safe environment** first
- [ ] **Review script contents** and understand actions
- [ ] **Check legal compliance** requirements

### During Use
- [ ] **Monitor execution** progress and logs
- [ ] **Verify intended targets** before confirming
- [ ] **Document activities** for compliance
- [ ] **Maintain communication** with stakeholders

### After Use
- [ ] **Verify destruction** completeness
- [ ] **Document completion** for records
- [ ] **Terminate cloud instances** if applicable
- [ ] **Review provider snapshots** and delete if needed

## Emergency Procedures

### If Run on Wrong System
1. **STOP IMMEDIATELY** (Ctrl+C if still running)
2. **Assess damage** - what has been destroyed
3. **Activate incident response** procedures
4. **Contact recovery specialists** if needed
5. **Document incident** for post-mortem

### If Unauthorized Use Suspected
1. **Isolate affected systems** immediately
2. **Preserve evidence** of unauthorized access
3. **Contact law enforcement** if criminal activity suspected
4. **Notify stakeholders** per incident response plan
5. **Review security controls** and access logs

---

**Remember**: This tool is essentially a digital weapon. Handle with extreme care and respect for its destructive power.
