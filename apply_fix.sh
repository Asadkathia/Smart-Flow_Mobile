#!/bin/bash
# Quick fix script for SmartFlowPro backend issue

echo "=========================================="
echo "SmartFlowPro Backend Fix"
echo "=========================================="
echo ""
echo "This script will apply the database fix."
echo ""
echo "You have 3 options:"
echo ""
echo "1. Open Supabase Dashboard SQL Editor (EASIEST)"
echo "2. Apply using Supabase CLI (requires password)"
echo "3. Cancel and do it manually"
echo ""
read -p "Choose option (1/2/3): " choice

case $choice in
  1)
    echo ""
    echo "Opening Supabase Dashboard..."
    open "https://supabase.com/dashboard/project/pbqbsdmwbjpsvxuuwjiv/sql"
    echo ""
    echo "✅ Dashboard opened!"
    echo ""
    echo "Now follow these steps:"
    echo "1. Click 'New Query'"
    echo "2. Open: supabase/FIX_TEST_USER.sql"
    echo "3. Copy all contents"
    echo "4. Paste into SQL Editor"
    echo "5. Click 'Run'"
    echo ""
    echo "Then run this script again and choose option 2 to apply the trigger."
    ;;
  2)
    echo ""
    echo "Applying database migrations..."
    cd /Users/asadkathia/Desktop/smartflowpro
    supabase db push --linked
    ;;
  3)
    echo ""
    echo "No problem! Follow the instructions in APPLY_FIX.md"
    ;;
  *)
    echo ""
    echo "Invalid option. Please run again and choose 1, 2, or 3."
    ;;
esac

echo ""
echo "For detailed instructions, see: APPLY_FIX.md"
echo "=========================================="
