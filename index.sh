items_file="items.txt"

# Function to display menu
display_menu() {
    echo "                                                         "
    echo "                                                         "
    echo "---------*-------*--------------*---------------*--------"
    echo "---------*-- Operations Of Gub Bus Management --*--------"
    echo "---------*-------*--------------*---------------*--------"
    echo "1. Add Bus"
    echo "2. Display Busses"
    echo "3. Update Buss"
    echo "4. Delete Buss"
    echo "5. Start Scheduling Busses"
    echo "6. Exit"
    echo "---------*-------*--------------*---------------*--------"
}

# Function to display items
display_items() {
    if [ ! -e "$items_file" ]; then
        echo "###- No items found."
    else
        echo "                                                         "
        echo "                                                         "
        echo "-------*--------*----------*-------*-----------"
        echo "------------ All Busses Information -----------"
        echo "-------*--------*----------*-------*-----------"
        cat "$items_file"
        
    fi
}


# Function to add Bus
add_item() {
    echo "###- Enter Bus name:"
    read name
    echo "###- Enter Bus serial number:"
    read serial
    echo "###- Enter source:"
    read source
    echo "###- Enter destination:"
    read destination
    echo "###- Enter Source To Destination distance:"
    read distance
    echo "###- Enter Departure priority:"
    read priority

    # Add item to the file
    echo "Name: $name | Serial: $serial | Source: $source | Destination: $destination | Distance: $distance | Priority: $priority" >> "$items_file"
    echo "###- Bus added successfully...!!"
    echo "                                                         "
    echo "                                                         "
}

# Function to update Bus
update_item() {
    echo "                                                         "
    echo "                                                         "
    echo "###- Enter the serial number of the Bus to update:"
    read serial

    # Search for the item in the file and update in-place
    if grep -q "Serial: $serial " "$items_file"; then
        echo "###- Enter New name:"
        read name
        echo "###- Enter New source:"
        read source
        echo "###- Enter New destination:"
        read destination
        echo "###- Enter New Source To Destination distance:"
        read distance
        echo "###- Enter New Departure priority:"
        read priority

        # Update the item in the file
        awk -v serial="$serial" -v name="$name" -v source="$source" -v destination="$destination" -v distance="$distance" -v priority="$priority" \
            'BEGIN {OFS=FS="|"} $2 == " Serial: "serial" " { $1 = "Name: "name" "; $3 = " Source: "source" "; $4 = " Destination: "destination" "; $5 = " Distance: "distance" "; $6 = " Priority: "priority" "; } { print $0 }' "$items_file" > tmpfile && mv tmpfile "$items_file"

        echo "                                                         "
        echo "                                                         "
        echo "###- Bus updated successfully!"
        echo "                                                         "
        echo "                                                         "
    else
        echo "                                                         "
        echo "                                                         "
        echo "###- Bus not found....!!"
        echo "                                                         "
        echo "                                                         "
    fi
}

# Function to delete item
delete_item() {
    echo "                                                         "
    echo "                                                         "
    echo "###- Enter the serial number of the item to delete:"
    read serial

    # Search for the item in the file
    if grep -q "Serial: $serial" "$items_file"; then
        # Delete the item from the file
        sed -i "/Serial: $serial/d" "$items_file"
        echo "###- Item deleted successfully!"
    else
        echo "###- Item not found."
    fi
}


# Function for FCFS (First-Come, First-Served) scheduling
fcfs_scheduling() {
    echo "                                                         "
    echo "                                                         "
    echo "###- FCFS Scheduling:"
    echo "-------*--------*----------*-------*-----------"
    awk -F\| '{print $1, $2, $3, $4, $5, $6 $7, $8, $9, $10, $11, $12}' "$items_file" | sort -k4n
    echo "                                                         "
    echo "                                                         "
}

# Function for SJF (Shortest Job First) scheduling
sjf_scheduling() {
    echo "                                                         "
    echo "                                                         "
    echo "###- SJF Scheduling:"
    echo "-------*--------*----------*-------*-----------"
    awk -F\| '{print $1, $2, $3, $4, $5, $6 $7, $8, $9, $10, $11, $12}' "$items_file" | sort -k10n
    echo "                                                         "
    echo "                                                         "
}

# Function for Priority Scheduling
priority_scheduling() {
    echo "                                                         "
    echo "                                                         "
    echo "###- Priority Scheduling:"
    echo "-------*--------*----------*-------*-----------"
    awk -F\| '{print $1, $2, $3, $4, $5, $6 $7, $8, $9, $10, $11, $12}' "$items_file" | sort -k12n
    echo "                                                         "
    echo "                                                         "
}

echo "                                                         "
echo "                                                         "
echo "---------*-------*--------------*---------------*--------"
echo "---------*-------*--------------*---------------*--------"
echo "----*-- Welcome To GUB Bus Management System  --*--------"
echo "----*------  Developed By: Emon & Elina  -------*--------"
echo "---------*-------*--------------*---------------*--------"
echo "---------*-------*--------------*---------------*--------"

# Main loop
while true; do
    display_menu
    read -p "###- Enter your choice: " choice

    case $choice in
        1) add_item ;;
        2) display_items ;;
        3) update_item ;;
        4) delete_item ;;
        5) 
            echo "                                                         "
            echo "                                                         "
            echo "###- Select Algorithm You Want to Apply for Departure of Busses:"
            echo "1. FCFS"
            echo "2. SJF"
            echo "3. Priority"
            read scheduling_choice

            case $scheduling_choice in
                1) fcfs_scheduling ;;
                2) sjf_scheduling ;;
                3) priority_scheduling ;;
                *) echo "Invalid scheduling algorithm." ;;
            esac
            ;;
        6) echo "Thank You For Using Our System. Bye for Now...." && break ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done