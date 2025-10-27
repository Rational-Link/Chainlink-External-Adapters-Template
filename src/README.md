# External Adapter Template (Express + TypeScript)
This script provides a simple External Adapter template for Chainlink nodes, built with Express, TypeScript, and Axios. It demonstrates how to receive requests from a Chainlink node, call an external API (in this case, Wikipedia), and return structured results back to the node.

## How It Works
1. Startup
  - The server runs on the port defined in PORT (default: 8080).
  - On startup, it listens for incoming HTTP requests.

2. Health Check
  - GET / returns a simple message confirming the adapter is running.

3. Job Execution
  - POST / accepts a JSON payload from the Chainlink node in the following format:
    ```json
    {
      "id": "1",
      "data": {
        "titles": "Albert Einstein",
        "exchars": 200
      }
    }
    ```
  - titles: The Wikipedia article title to query.
  - exchars (optional): Number of characters to return from the article extract.

4. External API Call
  - The adapter constructs a request to the Wikipedia API using the provided parameters.
  - It fetches the article extract and returns it in a structured response.
5. Response Format
  - On success:
  ```json
  {
    "jobRunId": "1",
    "statusCode": 200,
    "data": {
      "result": "Albert Einstein was a German-born theoretical physicist..."
    }
  }
  ```
  - On error:
  ```json
  {
    "jobRunId": "1",
    "statusCode": 500,
    "error": "Error message here"
  }
  ```

## Key Components
- Express: Handles HTTP requests and responses.
- Axios: Makes outbound API calls.
- TypeScript Types:
  - EAInput: Defines the expected request payload.
  - EAOutput: Defines the structured response format

## Tips for Clients
- Adapt the API Call:
  Replace the Wikipedia API logic with your own external data source. The structure is already in place for handling requests and returning results.
- Secure Your Adapter:
- In production, bind the adapter to the loopback interface (127.0.0.1) so it’s only accessible locally by the Chainlink node.
- Use TLS/HTTPS for secure communication.
- Consider adding authentication (e.g., signed JWTs) if your adapter will be exposed beyond localhost.
- Error Handling:
  The template includes basic error handling. Expand this to cover retries, timeouts, or more detailed error messages as needed.
- Scalability:
  For production, consider containerizing with Docker and managing with docker-compose or Kubernetes.
- Logging:
  Debug logs are included. Enhance logging for observability in production environments.

## Running Locally
```bash
# Install dependencies
npm install

# Start the server
npm run start
```
The adapter will be available at http://localhost:8080.

## Running on Docker
```bash
# Navigate to main directory where docker-compose.yml is located
docker compose up
```

## Example Request
```bash
curl -X POST http://localhost:8080/ \
  -H "Content-Type: application/json" \
  -d '{
    "id": "1",
    "data": {
      "titles": "Albert Einstein",
      "exchars": 150
    }
  }'
```

## Next Steps
Engaging with us to ensure that your adapter setup follows best practices for production-ready deployment.


