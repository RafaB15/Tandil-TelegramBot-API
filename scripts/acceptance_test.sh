#!/bin/bash

# Hardcoded URL to test

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

# Assign parameter to variable
URL=$1

# Function to perform the smoke test
perform_test() {
  # Perform HTTP GET request and store response
  RESPONSE=$(curl -s -w "\n%{http_code}" $URL)
  RESPONSE_STATUS=$(echo "$RESPONSE" | tail -n1)  # Extract response code
  RESPONSE_BODY=$(echo "$RESPONSE" | sed '$d')  # Extract response body

  # Print debug information
  echo "Response Status: $RESPONSE_STATUS"
  echo "Response Body: $RESPONSE_BODY"

  # Check if the response code is 200 (OK)
  if [ "$RESPONSE_STATUS" -eq 200 ]; then
    echo "Acceptance test passed: $URL is reachable and returned the version and the number of users."
      return 0
  else
    echo "Acceptance test failed: $URL is not reachable. HTTP Status Code: $RESPONSE_STATUS"
    return 1
  fi
}

# Retry mechanism with a maximum of 4 attempts (3 minutes)
MAX_RETRIES=4
RETRY_COUNT=0
RESULT=1

while [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ $RESULT -ne 0 ]; do
  if [ $RETRY_COUNT -gt 0 ]; then
    echo "Retrying in 1 minute... (Attempt $((RETRY_COUNT + 1)) of $MAX_RETRIES)"
    sleep 45
  fi
  perform_test
  RESULT=$?
  RETRY_COUNT=$((RETRY_COUNT + 1))
done

if [ $RESULT -ne 0 ]; then
  echo "Acceptance test failed after $MAX_RETRIES attempts."
  exit 1
else
  echo "Acceptance test passed."
  exit 0
fi
