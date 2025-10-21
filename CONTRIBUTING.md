# Contributing to VPS Nuke

Thank you for considering contributing to this project! Given the destructive nature of this software, we have strict guidelines to ensure safety and reliability.

## 🚨 CRITICAL SAFETY NOTICE

This project deals with **IRREVERSIBLE DATA DESTRUCTION**. All contributions must be:
- **Thoroughly tested** in isolated, disposable environments
- **Carefully reviewed** for unintended consequences
- **Properly documented** with clear warnings

## How to Contribute

### 🐛 Bug Reports

**Before submitting a bug report:**
- Search existing issues to avoid duplicates
- Test in a safe, isolated environment
- Gather detailed information about the environment

**Bug report should include:**
- **Environment details** (OS, distribution, version)
- **Command used** (exact arguments)
- **Expected behavior** vs **actual behavior**
- **Error messages** or logs
- **Steps to reproduce** (in safe environment)

### 💡 Feature Requests

**Good feature requests:**
- Enhance data destruction coverage
- Improve safety mechanisms
- Add support for new platforms/applications
- Better progress reporting
- Enhanced logging

**Please avoid requesting:**
- Data recovery features (contradicts purpose)
- Removal of safety checks
- Features that could enable misuse

### 🔧 Code Contributions

#### Development Environment Setup

1. **Use disposable systems** for testing:
   ```bash
   # Recommended: Docker containers or VMs
   docker run -it --rm ubuntu:latest bash
   ```

2. **Clone and setup**:
   ```bash
   git clone https://github.com/MyCato/vps-nuke.git
   cd vps-nuke
   chmod +x nuke_vps.sh
   ```

3. **Test safely**:
   ```bash
   # NEVER test on systems with real data
   # Use containers, VMs, or dedicated test systems
   ```

#### Code Style Guidelines

**Shell scripting standards:**
- Use `#!/usr/bin/env bash` shebang
- Enable strict mode: `set -euo pipefail`
- Use `|| true` for best-effort operations
- Include comprehensive error handling
- Add descriptive comments for complex operations

**Safety patterns:**
```bash
# Good: Check before destructive operations
if [[ -f "$file" ]]; then
    shred -u "$file" 2>/dev/null || true
fi

# Good: Use absolute paths
rm -rf /var/log/* 2>/dev/null || true

# Good: Validate block devices
if [[ ! -b "$device" ]]; then
    echo "Error: $device is not a block device"
    exit 1
fi
```

**Logging standards:**
```bash
# Use the log function with timestamps
log "Starting operation X"

# Include progress indicators for long operations
log "Step 1/5: Removing user data"
```

#### Testing Requirements

**All code changes must:**
1. **Pass syntax validation**:
   ```bash
   bash -n nuke_vps.sh  # Check syntax
   shellcheck nuke_vps.sh  # Static analysis
   ```

2. **Be tested in isolated environments**:
   - Docker containers (recommended)
   - Virtual machines
   - Cloud instances marked for destruction

3. **Include test scenarios**:
   - Normal operation paths
   - Error conditions
   - Edge cases (missing files, permission errors)

4. **Document test results**:
   - What was tested
   - Test environment details
   - Observed behavior
   - Any issues found

#### Pull Request Process

1. **Fork the repository**

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** following the guidelines above

4. **Test thoroughly** in disposable environments

5. **Update documentation**:
   - Update README.md if needed
   - Add CHANGELOG.md entry
   - Update comments in code

6. **Submit pull request** with:
   - Clear description of changes
   - Testing details and results
   - Any potential risks or considerations
   - Screenshots/logs if relevant

#### Pull Request Review Criteria

**We will evaluate:**
- **Safety**: Does it maintain or improve safety?
- **Functionality**: Does it work as intended?
- **Compatibility**: Works across different distributions?
- **Code quality**: Follows style guidelines?
- **Documentation**: Properly documented?
- **Testing**: Adequately tested?

## 📝 Documentation

### Areas needing documentation:
- Platform-specific behaviors
- New feature usage examples
- Troubleshooting guides
- Security considerations

### Documentation standards:
- Clear, concise language
- Include examples
- Highlight risks and warnings
- Use proper Markdown formatting

## 🚀 Enhancement Ideas

### High Priority
- **Additional database support** (MongoDB, Cassandra, etc.)
- **Cloud-specific optimizations** (AWS, GCP, Azure)
- **Progress reporting** improvements
- **Recovery prevention** techniques

### Medium Priority
- **Multiple disk wiping** automation
- **Configuration file** support
- **Logging enhancements**
- **Performance optimizations**

### Low Priority
- **GUI interface** (with extreme warnings)
- **Reporting features**
- **Integration scripts**

## 🛡️ Security Review Process

All contributions undergo security review:

1. **Code analysis** for potential vulnerabilities
2. **Safety mechanism** verification
3. **Misuse potential** assessment
4. **Legal compliance** check

## 📋 Code of Conduct

### Our Standards

**Positive behavior:**
- Respectful communication
- Constructive feedback
- Focus on safety and reliability
- Helping others understand risks

**Unacceptable behavior:**
- Encouraging misuse of the tool
- Sharing techniques to bypass safety measures
- Promoting unauthorized system destruction
- Harassment or discriminatory language

### Enforcement

Violations will result in:
1. **Warning** for minor issues
2. **Temporary ban** for repeated violations
3. **Permanent ban** for severe violations or malicious intent

## 🙋‍♀️ Questions?

- **General questions**: Open a GitHub issue
- **Security concerns**: Create a private security advisory on GitHub
- **Private discussions**: Use GitHub discussions

---

**Remember**: Every line of code you contribute could potentially destroy someone's data. Code responsibly! 💻💥
