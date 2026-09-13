#!/bin/bash

choice=0

until [ $choice -eq 10 ]
do
    echo ""
    echo "LINUX FILE MANAGER"
    sleep 0.5
    echo "
        1. Create a directory
        2. Create a file
        3. Rename a file
        4. Delete a file
        5. Delete a directory
        6. List files
        7. Search for a file or a word
        8. Backup a directory or a file
        9. Change file permissions
        10. Exit
      "
    sleep 0.5 
    echo "Enter your choice(1-10):"
    read -r choice

    case "$choice" in

        1)
            echo "Enter directory name or path:"
            read -r directory_name

            if [ -z "$directory_name" ]; then
            echo "Directory name cannot be empty."
            continue
            fi

            mkdir "$directory_name"

            result=$?

            if [ $result -eq 0 ]; then
                echo "The directory has been created!"
            else
                echo "It was not successful. Check if a directory with this name already exists."
            fi
            ;;

        2)
            echo "Enter file name or path:"
            read -r file_name

            if [ -z "$file_name" ]; then
                echo "File name cannot be empty."
                continue
            fi

            if [ -f "$file_name" ]; then
                echo "A file with this name already exists"
            else
                touch "$file_name"
                result=$?

                if [ $result -eq 0 ]; then
                    echo "The file has been created!"
                else
                    echo "The file could not be created."
                fi
            fi
            ;;

        3)
            echo "Enter the current file name:"
            read -r current_filename

            if [ -z "$current_filename" ]; then
                echo "Current file name cannot be empty."
                continue
            fi

            if [ -f "$current_filename" ]; then
                echo "Enter the new file name:"
                read -r new_filename

                if [ -z "$new_filename" ]; then
                    echo "New file name cannot be empty."
                    continue
                fi

                if [ -f "$new_filename" ]; then
                    echo "Warning! A file with this name already exists."
                else
                    mv "$current_filename" "$new_filename"
                    result=$?

                    if [ $result -eq 0 ]; then
                        echo "File renamed successfully!"
                    else
                        echo "The file could not be renamed."
                    fi
                fi

            else
                echo "The file you entered does not exist."
            fi
            ;;

        4)
            echo "Enter the name of the file you want to delete:"
            read -r delete_file

            if [ -z "$delete_file" ]; then
              echo "File name cannot be empty."
            continue
            fi

            if [ -f "$delete_file" ]; then
                echo "Are you sure you want to delete this file?(y/Y or n/N)"
                read -r confirmation

            if [ -z "$confirmation" ]; then
              echo "Input cannot be empty."
            continue
            fi

                case "$confirmation" in

                    y|Y)
                        rm "$delete_file"
                        result=$?

                        if [ $result -eq 0 ]; then
                            echo "File deleted successfully!"
                        else
                            echo "The file could not be deleted."
                        fi
                        ;;

                    n|N)
                        echo "Task canceled by user"
                        ;;

                    *)
                        echo "Invalid entry"
                        ;;

                esac

            else
                echo "The file does not exist"
            fi
            ;;

        5)
            echo "Enter the directory name or path:"
            read -r delete_dir

            if [ -z "$delete_dir" ]; then
              echo "Directory name cannot be empty."
            continue
            fi

            if [ -d "$delete_dir" ]; then
                file_count=$(ls -A "$delete_dir" | wc -l)

                if [ "$file_count" -eq 0 ]; then
                    rmdir "$delete_dir"
                    result=$?

                    if [ $result -eq 0 ]; then
                        echo "Directory deleted successfully!"
                    else
                        echo "The directory could not be deleted."
                    fi

                else
                    echo "Are you sure you want to delete the entire directory?(y/Y n/N)"
                    read -r confirmation

                    if [ -z "$confirmation" ]; then
                        echo "Input cannot be empty."
                    continue
                    fi 

                    case "$confirmation" in

                        y|Y)
                            rm -R "$delete_dir"
                            result=$?

                            if [ $result -eq 0 ]; then
                                echo "Directory deleted successfully!"
                            else
                                echo "The directory could not be deleted."
                            fi
                            ;;

                        n|N)
                            echo "Task canceled by user"
                            ;;

                        *)
                            echo "Invalid entry"
                            ;;

                    esac
                fi

            else
                echo "The directory does not exist"
            fi
            ;;

        6)
            echo "Enter the name of the directory:"
            read -r list_dir

            if [ -z "$list_dir" ]; then
              echo "Directory name cannot be empty."
            continue
            fi

            if [ -d "$list_dir" ]; then
                ls "$list_dir"
                sleep 1
                echo ""
                echo "Do you want to see hidden files? (y/Y or n/N)"
                read -r confirmation

                if [ -z "$confirmation" ]; then
                  echo "Input cannot be empty."
                continue
                fi

                case "$confirmation" in

                    y|Y)
                        ls -A "$list_dir"
                        ;;

                    n|N)
                        echo "Okay, no hidden files"
                        ;;

                    *)
                        echo "Invalid entry"
                        ;;

                esac

            else
                echo "The directory does not exist."
            fi
            ;;

        7)
            echo "What do you want to search for?"
            echo "1. A file"
            echo "2. A word"
            echo "Enter your choice (1 or 2):"
            read -r search_choice

            if [ -z "$search_choice" ]; then
                  echo "Input cannot be empty."
                continue
                fi

            case "$search_choice" in

                1)
                    echo "Enter the directory/path to search in:"
                    read -r search_path

                    if [ -z "$search_path" ]; then
                  echo "Search path cannot be empty."
                continue
                fi

                    if [ -d "$search_path" ]; then
                        echo "Enter the name of the file you want to search for:"
                        read -r search_file

                        if [ -z "$search_file" ]; then
                          echo "File name cannot be empty."
                       continue
                       fi

                        file_count=$(find "$search_path" -type f -name "$search_file" | wc -l)

                        if [ "$file_count" -eq 0 ]; then
                            echo "The file could not be found."
                        else
                            find "$search_path" -type f -name "$search_file"
                        fi

                    else
                        echo "The directory/path does not exist."
                    fi
                    ;;

                2)
                    echo "Enter the directory/path to search in:"
                    read -r search_path

                if [ -z "$search_path" ]; then
                  echo "Search path cannot be empty."
                continue
                fi

                    if [ -d "$search_path" ]; then
                        echo "Enter the word you want to search for :"
                        read -r search_word
                    
                if [ -z "$search_word" ]; then
                  echo "Input cannot be empty."
                continue
                fi



                        word_count=$(grep -ro "$search_word" "$search_path" | wc -w)

                        if [ "$word_count" -eq 0 ]; then
                            echo "The word could not be found"
                        else
                            grep -rn "$search_word" "$search_path"
                        fi

                    else
                        echo "The directory/path does not exist."
                    fi
                    ;;

                *)
                    echo "Invalid search choice. Please enter 1 or 2"
                    ;;

            esac
            ;;

        8)
            echo "What do you want to backup?"
            echo "1. A file"
            echo "2. A directory"
            echo "Enter your choice (1 or 2):"
            read -r backup_choice

            case "$backup_choice" in

                1)
                    # backup file
                    echo "Enter the file name or path:"
                    read -r file_path

                    if [ -z "$file_path" ]; then
                        echo "File path cannot be empty."
                        continue
                    fi

                    if [ -f "$file_path" ]; then
                        echo "Enter the backup directory:"
                        read -r backup_dir

                    if [ -z "$backup_dir" ]; then
                        echo "Backup directory cannot be empty."
                        continue
                    fi 

                        if [ -d "$backup_dir" ]; then
                            cp "$file_path" "$backup_dir"
                            result=$?

                            if [ "$result" -eq 0 ]; then
                                echo "The file backup was successful."
                            else
                                echo "The file backup was not successful."
                            fi

                        else
                            echo "The directory does not exist."
                            echo "Do you want to create it? (y/Y n/N)"
                            read -r create_dir

                            if [ -z "$create_dir" ]; then
                                echo "Input cannot be empty."
                                continue
                            fi

                            case "$create_dir" in

                                n|N)
                                    echo "Okay, returning to the main menu..."
                                    sleep 0.5
                                    ;;

                                y|Y)
                                    echo "Creating $backup_dir..."
                                    sleep 0.5

                                    mkdir "$backup_dir" && cp "$file_path" "$backup_dir"
                                    result=$?

                                    if [ "$result" -eq 0 ]; then
                                        echo "The directory has been created and your file backup was successful."
                                    else
                                        echo "The directory could not be created or the file backup was not successful."
                                    fi
                                    ;;

                                *)
                                    echo "Invalid entry!"
                                    ;;

                            esac
                        fi

                    else
                        echo "The file does not exist."
                    fi
                    ;;

                2)
                    # backup directory
                    echo "Enter the directory name or path:"
                    read -r dir_path

                    if [ -z "$dir_path" ]; then
                        echo "Directory path cannot be empty."
                        continue
                    fi

                    if [ -d "$dir_path" ]; then
                        echo "Enter the backup directory:"
                        read -r backup_dir

                    if [ -z "$backup_dir" ]; then
                        echo "Backup directory be empty."
                        continue
                    fi

                        if [ -d "$backup_dir" ]; then
                            cp -r "$dir_path" "$backup_dir"
                            result=$?

                            if [ "$result" -eq 0 ]; then
                                echo "The directory backup was successful."
                            else
                                echo "The directory backup was not successful."
                            fi

                        else
                            echo "The directory does not exist."
                            echo "Do you want to create it? (y/Y n/N)"
                            read -r create_dir

                        if [ -z "$create_dir" ]; then
                        echo "Input cannot be empty."
                        continue
                        fi

                            case "$create_dir" in

                                n|N)
                                    echo "Okay, returning to the main menu..."
                                    sleep 0.5
                                    ;;

                                y|Y)
                                    echo "Creating $backup_dir..."
                                    sleep 0.5

                                    mkdir "$backup_dir" && cp -r "$dir_path" "$backup_dir"
                                    result=$?

                                    if [ "$result" -eq 0 ]; then
                                        echo "The directory has been created and your directory backup was successful."
                                    else
                                        echo "The directory could not be created or the directory backup was not successful."
                                    fi
                                    ;;

                                *)
                                    echo "Invalid entry!"
                                    ;;

                            esac
                        fi

                    else
                        echo "The directory does not exist."
                    fi
                    ;;

                *)
                    # invalid choice
                    echo "Invalid entry!"
                    ;;

            esac
            ;;

        9)
        echo "Enter the name of the file or path:"
        read -r permission_file

        if [ -z "$permission_file" ]; then
            echo "File name cannot be empty."
        continue
        fi

            if [ -f "$permission_file" ]; then
                echo "Current permissions:"
                ls -l "$permission_file"

                echo ""
                echo "Permission format: XYZ"
                echo "First number  = Owner"
                echo "Second number = Group"
                echo "Third number  = Others"
                echo ""
                echo "r = 4"
                echo "w = 2"
                echo "x = 1"
                echo ""
                echo "Example: 644"
                echo "6 = read and write"
                echo "4 = read"
                echo "4 = read"
                echo ""

                echo "Enter the new permission number:"
                read -r permission_mode

                     if [ -z "$permission_mode" ]; then
                       echo "Permission number cannot be empty."
                    continue
                    fi

                if [[ ! "$permission_mode" =~ ^[0-7]{3,4}$ ]]; then
                   echo "Invalid permission format."
                continue
                fi

                chmod "$permission_mode" "$permission_file"
                result=$?

                if [ "$result" -eq 0 ]; then
                    echo "File permissions changed successfully!"
                    echo "Permission has been changed to:" 
                    ls -l "$permission_file"
                else
                    echo "The file permissions could not be changed."
                fi

            else
                echo "The file does not exist."
            fi
        ;;
        
        10)
            echo "Thank you for using Linux File Manager!"
            ;;

        *)
            echo "Invalid option"
            ;;

    esac

done
