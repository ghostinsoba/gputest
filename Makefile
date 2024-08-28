publish:
	docker build -f Dockerfile -t ghcr.io/ghostinsoba/gputest:develop .
	docker push ghcr.io/ghostinsoba/gputest:develop