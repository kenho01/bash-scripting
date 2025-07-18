# Shebang statement to tell the OS which interpreter to use to run the file
#!/bin/bash

# Variables
LOG_DIR="/Users/kenho/Documents/GitHub/bash-scripting/logs"

# No space
# No comma delimiter in array variable
ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")
REPORT_FILE="/Users/kenho/Documents/GitHub/bash-scripting/logs/logs_analysis_report.txt"

echo "Analysing log files" > "$REPORT_FILE"
echo "====================" >> "$REPORT_FILE"

# -e to not interpret \n as string
echo -e "\nList of log files updated in the last 24 hours"
# Use absolute path to make it more robust
LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -1)
echo "$LOG_FILES" >> "$REPORT_FILE"

for LOG_FILE in $LOG_FILES; do 
    echo -e "\n" >> "$REPORT_FILE"
    echo "==========================================================================" >> "$REPORT_FILE"
    echo "===================$LOG_FILE=======================" >> "$REPORT_FILE"
    echo "==========================================================================" >> "$REPORT_FILE"

    for PATTERN in ${ERROR_PATTERNS[@]}; do
        echo -e "\nSearching $PATTERN logs in $LOG_FILE file" >> "$REPORT_FILE"
        grep "$PATTERN" "$LOG_FILE" >> "$REPORT_FILE"

        echo -e "\nNumber of $PATTERN logs found in $LOG_FILE" >> "$REPORT_FILE"

        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo -e "[WARNING] Action Required: Too many $PATTERN issues in log file $LOG_FILE"
        fi 
        grep -c "$PATTERN" "$LOG_FILE" >> "$REPORT_FILE"
    done

done

echo -e "\nLog analysis completed and report saved in: $REPORT_FILE"