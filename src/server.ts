import process from "process";
import express, { Express, Request, Response } from "express";
import bodyParser from "body-parser";
import axios from "axios";

type EAInput = {
  id: number | string;
  data: {
    // Accept the article title and optional number of characters for extracts
    titles: string;
    exchars?: number;  // Made optional with ?
  };
};

type EAOutput = {
  jobRunId: string | number;
  statusCode: number;
  data: {
    result?: any;
  };
  error?: string;
};

const PORT = process.env.PORT || 8080;
const app: Express = express();

app.use(bodyParser.json());

app.get("/", function (req: Request, res: Response) {
  res.send("Hello! Thank you for using this External Adapter template. - Rational Link");
});

app.post("/", async function (req: Request<{}, {}, EAInput>, res: Response) {
  const eaInputData: EAInput = req.body;
  console.log(" Request data received: ", eaInputData);

  // Build MediaWiki API request with the provided titles and optional exchars
  const titles = eaInputData.data.titles;
  const exchars = eaInputData.data.exchars;

  const params = new URLSearchParams({
    action: "query",
    format: "json",
    prop: "extracts",
    exintro: "true",
    explaintext: "true",
    titles: titles,
  });

  if (typeof exchars === 'number') {
    // Ensure exchars is a positive integer
    const excharsInt = Math.trunc(exchars);
    if (excharsInt > 0) {
      params.set("exchars", String(excharsInt));
    }
  }

  const url = `https://en.wikipedia.org/w/api.php?${params.toString()}`;
  // Debug logging to help verify incoming payload and constructed query
  // console.log("Parsed request fields -> titles:", titles, "exchars:", exchars);
  // console.log("Constructed MediaWiki API URL:", url);



  let eaResponse: EAOutput = {
    data: {},
    jobRunId: eaInputData.id,
    statusCode: 0,
  };

  try {
    const apiResponse = await axios.get(url);
    
    // Extract just the page extract from the MediaWiki API response
    const pages = apiResponse.data.query?.pages || {};
    const firstPageId = Object.keys(pages)[0];
    const extract = firstPageId ? pages[firstPageId].extract : null;

    eaResponse.data = { result: extract };
    eaResponse.statusCode = apiResponse.status;

    res.json(eaResponse);
  } catch (error: any) {
    console.error("API Response Error: ", error);
    eaResponse.error = error.message;
    eaResponse.statusCode = error.response.status;

    res.json(eaResponse);
  }

  console.log("returned response:  ", eaResponse);
  return;
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

process.on("SIGINT", () => {
  console.info("\nShutting down server...");
  process.exit(0);
});

