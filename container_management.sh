#!/bin/bash

# Function to display menu
display_menu() {
    echo -e "\nDocker Container Management Menu"
    echo "1. Launch a container"
    echo "2. Pull an image"
    echo "3. Stop a container"
    echo "4. List all images"
    echo "5. List all running containers"
    echo "6. List all containers (running and stopped)"
    echo "7. Remove a container"
    echo "8. Remove an image"
    echo "9. Stop all containers"
    echo "10. Remove all containers"
    echo "11. Remove all images"
    echo "12. Create a Dockerfile"
    echo "13. Build an image from Dockerfile"
    echo "14. Attach to a running container"
    echo "15. Create a network"
    echo "16. List all networks"
    echo "17. Inspect a network"
    echo "18. Remove a network"
    echo "19. Launch a container using a network"
    echo "20. Exit"
    echo -n "Enter your choice: "
}

# Function to launch a container
launch_container() {
    read -p "Enter the name for the container: " container_name
    read -p "Enter the image name (e.g., ubuntu:latest): " image_name
    docker run -dit --name "$container_name" "$image_name" && \
    echo "Container '$container_name' launched successfully." || \
    echo "Failed to launch container '$container_name'."
}

# Function to pull an image
pull_image() {
    read -p "Enter the image name (e.g., ubuntu:latest): " image_name
    docker pull "$image_name" && \
    echo "Image '$image_name' pulled successfully." || \
    echo "Failed to pull image '$image_name'."
}

# Function to stop a container
stop_container() {
    read -p "Enter the name of the container to stop: " container_name
    docker stop "$container_name" && \
    echo "Container '$container_name' stopped successfully." || \
    echo "Failed to stop container '$container_name'."
}

# Function to list all images
list_images() {
    echo -e "\nListing all images:"
    docker images
}

# Function to list all running containers
list_running_containers() {
    echo -e "\nListing all running containers:"
    docker ps
}

# Function to list all containers
list_all_containers() {
    echo -e "\nListing all containers (running and stopped):"
    docker ps -a
}

# Function to remove a container
remove_container() {
    read -p "Enter the name of the container to remove: " container_name
    docker rm "$container_name" && \
    echo "Container '$container_name' removed successfully." || \
    echo "Failed to remove container '$container_name'."
}

# Function to remove an image
remove_image() {
    read -p "Enter the name of the image to remove: " image_name
    docker rmi "$image_name" && \
    echo "Image '$image_name' removed successfully." || \
    echo "Failed to remove image '$image_name'."
}

# Function to stop all containers
stop_all_containers() {
    docker stop $(docker ps -q) && \
    echo "All running containers stopped successfully." || \
    echo "Failed to stop all running containers."
}

# Function to remove all containers
remove_all_containers() {
    docker rm -f $(docker ps -aq) && \
    echo "All containers removed successfully." || \
    echo "Failed to remove all containers."
}

# Function to remove all images
remove_all_images() {
    docker rmi $(docker images -q) && \
    echo "All images removed successfully." || \
    echo "Failed to remove all images."
}

# Function to create a Dockerfile
create_dockerfile() {
    read -p "Enter the base image (e.g., ubuntu:latest): " base_image
    echo "Enter additional Dockerfile instructions (end with an empty line):"
    
    instructions=""
    while true; do
        read line
        if [[ -z "$line" ]]; then
            break
        fi
        instructions+="$line"$'\n'
    done

    cat > Dockerfile <<EOF
FROM $base_image
$instructions
EOF

    echo "Dockerfile created successfully."
}

# Function to build an image from Dockerfile
build_dockerfile() {
    read -p "Enter the name for the image to build: " image_name
    docker build -t "$image_name" . && \
    echo "Image '$image_name' built successfully." || \
    echo "Failed to build image '$image_name'."
}

# Function to attach to a running container
attach_container() {
    read -p "Enter the name or ID of the container to attach to: " container_name
    docker attach "$container_name"
}

# Function to create a network
create_network() {
    read -p "Enter the name for the network: " network_name
    read -p "Enter the driver type (default: bridge): " driver_type
    driver_type=${driver_type:-bridge}
    docker network create --driver "$driver_type" "$network_name" && \
    echo "Network '$network_name' created successfully." || \
    echo "Failed to create network '$network_name'."
}

# Function to list all networks
list_networks() {
    echo -e "\nListing all Docker networks:"
    docker network ls
}

# Function to inspect a network
inspect_network() {
    read -p "Enter the name or ID of the network to inspect: " network_name
    docker network inspect "$network_name"
}

# Function to remove a network
remove_network() {
    read -p "Enter the name or ID of the network to remove: " network_name
    docker network rm "$network_name" && \
    echo "Network '$network_name' removed successfully." || \
    echo "Failed to remove network '$network_name'."
}

# Function to launch a container using a network
launch_container_with_network() {
    read -p "Enter the name for the container: " container_name
    read -p "Enter the image name (e.g., ubuntu:latest): " image_name
    read -p "Enter the network name: " network_name
    docker run -dit --name "$container_name" --network "$network_name" "$image_name" && \
    echo "Container '$container_name' launched successfully on network '$network_name'." || \
    echo "Failed to launch container '$container_name' on network '$network_name'."
}

# Main script loop
while true; do
    display_menu
    read choice

    case $choice in
        1)
            launch_container ;;
        2)
            pull_image ;;
        3)
            stop_container ;;
        4)
            list_images ;;
        5)
            list_running_containers ;;
        6)
            list_all_containers ;;
        7)
            remove_container ;;
        8)
            remove_image ;;
        9)
            stop_all_containers ;;
        10)
            remove_all_containers ;;
        11)
            remove_all_images ;;
        12)
            create_dockerfile ;;
        13)
            build_dockerfile ;;
        14)
            attach_container ;;
        15)
            create_network ;;
        16)
            list_networks ;;
        17)
            inspect_network ;;
        18)
            remove_network ;;
        19)
            launch_container_with_network ;;
        20)
            echo "Exiting..."
            exit 0 ;;
        *)
            echo "Invalid choice. Please try again." ;;
    esac

done
