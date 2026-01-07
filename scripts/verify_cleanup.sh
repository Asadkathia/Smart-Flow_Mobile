#!/bin/bash

# SmartFlowPro Cleanup Verification Script
# This script verifies that all GetX code has been removed and cleanup is complete

echo "🔍 SmartFlowPro Cleanup Verification"
echo "======================================"
echo ""

ERRORS=0
WARNINGS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check and report
check_pattern() {
    local pattern=$1
    local description=$2
    local count=$(grep -r "$pattern" lib/ 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$count" -gt 0 ]; then
        echo -e "${RED}❌ $description: Found $count occurrences${NC}"
        grep -r "$pattern" lib/ 2>/dev/null | head -5
        if [ "$count" -gt 5 ]; then
            echo "   ... and $((count - 5)) more"
        fi
        ERRORS=$((ERRORS + 1))
        return 1
    else
        echo -e "${GREEN}✅ $description: Clean${NC}"
        return 0
    fi
}

# Function to check files exist
check_file_exists() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo -e "${YELLOW}⚠️  $description: File still exists${NC}"
        WARNINGS=$((WARNINGS + 1))
        return 1
    else
        echo -e "${GREEN}✅ $description: Removed${NC}"
        return 0
    fi
}

# Function to check file doesn't exist
check_file_removed() {
    local file=$1
    local description=$2
    
    if [ ! -f "$file" ]; then
        echo -e "${GREEN}✅ $description: Removed${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  $description: Still exists (may be needed)${NC}"
        WARNINGS=$((WARNINGS + 1))
        return 1
    fi
}

echo "📦 Checking Dependencies..."
echo "---------------------------"

# Check pubspec.yaml for GetX
if grep -q "get:" pubspec.yaml 2>/dev/null; then
    echo -e "${RED}❌ GetX package still in pubspec.yaml${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ GetX package removed from pubspec.yaml${NC}"
fi

echo ""
echo "🔍 Checking for GetX Code Patterns..."
echo "-------------------------------------"

# Check for GetX imports
check_pattern "import 'package:get/get.dart'" "GetX imports"
check_pattern "import 'package:get/getx.dart'" "GetX imports (getx.dart)"

# Check for GetX classes
check_pattern "extends GetxController" "GetxController classes"
check_pattern "extends GetView" "GetView classes"
check_pattern "GetxController" "GetxController references"

# Check for GetX reactive patterns
check_pattern "\.obs" "Reactive variables (.obs)"
check_pattern "Obx\(" "Obx widgets"

# Check for GetX navigation
check_pattern "Get\.toNamed" "Get.toNamed() calls"
check_pattern "Get\.back" "Get.back() calls"
check_pattern "Get\.offAllNamed" "Get.offAllNamed() calls"
check_pattern "Get\.offNamed" "Get.offNamed() calls"
check_pattern "Get\.snackbar" "Get.snackbar() calls"
check_pattern "Get\.dialog" "Get.dialog() calls"
check_pattern "Get\.bottomSheet" "Get.bottomSheet() calls"

# Check for GetX routes
check_pattern "GetPage" "GetPage routes"
check_pattern "GetMaterialApp" "GetMaterialApp"

echo ""
echo "📁 Checking File Structure..."
echo "-----------------------------"

# Check for old controller files (should be removed after migration)
echo "Checking for old controllers (should be removed after migration):"
check_file_removed "lib/app/modules/auth/login/controller/login_controller.dart" "LoginController"
check_file_removed "lib/app/modules/auth/signup/controller/signup_controller.dart" "SignupController"
check_file_removed "lib/app/modules/Home/controller/home_page_controller.dart" "HomePageController"
check_file_removed "lib/app/modules/job_details/controller/job_details_controller.dart" "JobDetailsController"

# Check for binding files (should be removed)
echo ""
echo "Checking for old bindings (should be removed):"
BINDING_COUNT=$(find lib/app/modules -name "*_binding.dart" -o -name "*_bindings.dart" 2>/dev/null | wc -l | tr -d ' ')
if [ "$BINDING_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found $BINDING_COUNT binding files${NC}"
    find lib/app/modules -name "*_binding.dart" -o -name "*_bindings.dart" 2>/dev/null | head -5
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ No binding files found${NC}"
fi

# Check for old routes (should be replaced with GoRouter)
echo ""
echo "Checking for old GetX routes:"
if [ -f "lib/app/routes/app_pages.dart" ]; then
    if grep -q "GetPage" lib/app/routes/app_pages.dart 2>/dev/null; then
        echo -e "${YELLOW}⚠️  app_pages.dart still uses GetPage (should migrate to GoRouter)${NC}"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "${GREEN}✅ app_pages.dart doesn't use GetPage${NC}"
    fi
fi

echo ""
echo "🧹 Checking Code Quality..."
echo "---------------------------"

# Check for unused imports
echo "Running flutter analyze..."
ANALYZE_OUTPUT=$(flutter analyze 2>&1)
ANALYZE_EXIT=$?

if [ $ANALYZE_EXIT -eq 0 ]; then
    echo -e "${GREEN}✅ Flutter analyze passed${NC}"
else
    echo -e "${RED}❌ Flutter analyze found issues:${NC}"
    echo "$ANALYZE_OUTPUT" | head -20
    ERRORS=$((ERRORS + 1))
fi

# Check for TODO comments related to cleanup
TODO_COUNT=$(grep -r "TODO.*GetX\|TODO.*cleanup\|TODO.*remove.*Get" lib/ 2>/dev/null | wc -l | tr -d ' ')
if [ "$TODO_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found $TODO_COUNT TODO comments related to cleanup${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "📊 Summary"
echo "=========="
echo -e "Errors: ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Cleanup verification PASSED!${NC}"
    echo -e "${GREEN}All GetX code has been successfully removed.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Cleanup verification PASSED with warnings${NC}"
    echo -e "${YELLOW}Review warnings above and address if needed.${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ Cleanup verification FAILED${NC}"
    echo -e "${RED}Please fix the errors above before proceeding.${NC}"
    exit 1
fi



