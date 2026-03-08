from aceest import create_app

app = create_app()

if __name__ == "__main__":
    # Port 5002 chosen to avoid macOS AirPlay Receiver (5000) and Docker Deploy (5001) conflicts
    app.run(host="0.0.0.0", port=5002)
