# Heygen Voice Explorer

A beautiful UI built with Vue.js and Tailwind CSS to explore, filter, and preview Heygen AI voices.

## Features

- Browse hundreds of AI voices from the Heygen platform
- Filter by language, gender, and emotion support
- Search voices by name
- Listen to voice previews directly in the browser
- Responsive design for desktop and mobile
- Secure API access through server-side proxy
- Dark mode support with toggle (enabled by default)

## Tech Stack

- Vue.js 3
- Tailwind CSS
- Express.js backend proxy
- Axios for API requests

## Project Setup

```
npm install
```

### Development - Frontend Only

```
npm run serve
```

### Development with Secure Backend Proxy

```
npm run dev:server
```

### Compile and Minify for Production

```
npm run build
```

### Start Production Server

```
npm start
```

## Security Implementation

This application implements proper API key security by:

1. Using server-side proxy to keep API key private
2. Storing the API key in environment variables
3. Including the API key only in server-side requests
4. Never exposing the API key to client-side code

### Setting up Environment Variables

Create a `.env` file in the root directory:

```
VUE_APP_HEYGEN_API_KEY=your_api_key_here
```

## Docker Deployment

The application includes a multi-stage Docker setup for easy deployment.

### Prerequisites

- Docker
- Docker Compose

### Building and Deploying with Docker

1. Create a `.env` file with your Heygen API key:

```
VUE_APP_HEYGEN_API_KEY=your_api_key_here
```

2. Build the Docker image:

```
chmod +x build.sh
./build.sh
```

3. Deploy with Docker Compose:

```
chmod +x deploy.sh
./deploy.sh
```

The application will be available at http://localhost:3000.

### Manual Docker Commands

If you prefer not to use the scripts, you can run these commands manually:

```bash
# Build the Docker image
docker build -t heygen-voice-explorer:latest .

# Run with Docker Compose
docker-compose up -d
```

### Deployment to Production

For production environments:

1. Update the Docker Compose file with your production settings if needed
2. Ensure your API key is securely set in your production environment
3. Run the deployment script or Docker Compose commands

## Standard Deployment

For production deployment without Docker:

1. Set your API key in the environment variables on your hosting platform
2. Build the Vue.js frontend with `npm run build`
3. Start the server with `npm start`

## API Documentation

The application uses the Heygen API to fetch voice data. For more information, refer to the [Heygen API documentation](https://docs.heygen.com/). 