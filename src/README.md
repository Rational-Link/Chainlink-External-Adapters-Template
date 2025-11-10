## External Adapter Template (Express + TypeScript)
This script provides a simple External Adapter template for Chainlink nodes, built with Express, TypeScript, and Axios. It demonstrates how to receive requests from a Chainlink node, call an external API (in this case, Wikipedia), and return structured results back to the node.

### How It Works
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

### Key Components
- Express: Handles HTTP requests and responses.
- Axios: Makes outbound API calls.
- TypeScript Types:
  - EAInput: Defines the expected request payload.
  - EAOutput: Defines the structured response format.

### Tips for Clients
- Adapt the API Call:
  Clients can replace the sample Wikipedia API logic with their own external data source. The provided structure is already designed to handle requests and return results seamlessly.
- Production Environment:
  Clients should be aware that in the production environment hosted by Rational Link, the adapter is bound to the loopback interface so it is only accessible locally by the Chainlink node. In addition, all communication between the node and the adapter is secured using TLS/HTTPS.
- Advanced Customization:
  If clients require more advanced customization—such as enhanced error handling and retries, or API key authentication—Rational Link will collaborate closely to tailor the solution to their needs. Every effort will be made to align with client timelines, and this assistance is provided with minimal onboarding fees.


### Running Locally
```bash
# Install dependencies
npm install

# Start the server
npm run start
```
The adapter will be available at http://localhost:8080.

### Running on Docker
```bash
# Navigate to main directory where docker-compose.yml is located
docker compose up
```

### Example Request
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

### Next Steps
Engage with us to ensure that your adapter setup follows best practices for production-ready deployment.


