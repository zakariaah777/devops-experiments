#!/bin/bash
# Test script voor Jenkins TestAppJob
# Experiment J1 - Jenkins CI/CD Lab

# Kleuren voor output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================="
echo "Testing Sample App..."
echo "=================================="

# Test of de app bereikbaar is en de juiste content teruggeeft
if curl http://172.17.0.1:5050/ | grep "You are calling me from 172.17.0.1"; then
    echo -e "${GREEN}✓ Test PASSED: App is running and responding correctly${NC}"
    exit 0
else
    echo -e "${RED}✗ Test FAILED: App is not responding correctly${NC}"
    exit 1
fi
