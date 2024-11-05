# Configuration for Scripts

This repository contains various scripts that require configuration settings. The configurations can be managed using configuration files and environment variables. This document explains how to set up and use these configurations.

## Configuration Files

Configuration files are stored in the `.config` directory. Each script has its own configuration file with settings specific to that script. Example configuration files are provided with the `.example` extension. These example files should be copied and modified as needed.

### Example Configuration Files

- `.config/ords_info.conf.example`
- `.config/another_config.conf.example`

### Creating Configuration Files

To create a configuration file, copy the example file and modify the values as needed. For example:

```sh
cp .config/ords_info.conf.example .config/ords_info.conf
```