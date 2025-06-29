# Use official Node.js image
FROM node:14

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Expose app port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
