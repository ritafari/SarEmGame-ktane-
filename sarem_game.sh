#!/bin/bash

# Game settings
TIME_LIMIT_LEVEL1=30  # seconds for Level 1
TIME_LIMIT_LEVEL2=20  # seconds for Level 2
TIME_LIMIT_LEVEL3=15  # seconds for Level 3
MAX_STRIKES=3         # number of allowed mistakes

# Declare modules for each level
declare -A LEVEL1_MODULES=(
    ["color"]="Solve the color puzzle"
    ["math"]="Solve the math puzzle"
)
declare -A LEVEL2_MODULES=(
    ["sequence"]="Solve the sequence puzzle"
    ["riddle"]="Solve the riddle"
)
declare -A LEVEL3_MODULES=(
    ["cipher"]="Decode the cipher"
    ["pattern"]="Complete the pattern puzzle"
    ["word"]="Unscramble the word"
)

# Game variables
strikes=0
modules_solved=0

# Prompt the user with a time limit for each question
function prompt_with_timeout() {
    local prompt="$1"
    local timeout="$2"
    echo "$prompt"
    
    read -t "$timeout" answer  # Read with timeout
    if [ $? -eq 0 ]; then      # Check if the user responded in time
        echo "$answer"
    else
        echo ""
    fi
}

# Level 1 module functions
function color_module() {
    echo -e "\nModule: Colors"
    local response
    response=$(prompt_with_timeout "The color module requires you to answer with the complementary color of 'blue'." 30)
    if [ "$response" == "orange" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

function math_module() {
    echo -e "\nModule: Math"
    local response
    response=$(prompt_with_timeout "Solve: What is 7 * 8?" 30)
    if [ "$response" == "56" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

# Level 2 module functions
function sequence_module() {
    echo -e "\nModule: Sequence"
    local response
    response=$(prompt_with_timeout "What comes next in the sequence: 2, 4, 6, ?" 20)
    if [ "$response" == "8" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

function riddle_module() {
    echo -e "\nModule: Riddle"
    local response
    response=$(prompt_with_timeout "What has keys but can't open locks?" 20)
    if [ "$response" == "piano" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

# Level 3 module functions
function cipher_module() {
    echo -e "\nModule: Cipher"
    local response
    response=$(prompt_with_timeout "Decode the word 'GRFG' using Caesar Cipher with a shift of 13." 15)
    if [ "$response" == "TEST" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

function pattern_module() {
    echo -e "\nModule: Pattern"
    local response
    response=$(prompt_with_timeout "What comes next in the pattern: 1, 4, 9, 16, ?" 15)
    if [ "$response" == "25" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

function word_module() {
    echo -e "\nModule: Word Scramble"
    local response
    response=$(prompt_with_timeout "Unscramble the letters: 'AEPPL'" 15)
    if [ "$response" == "APPLE" ]; then
        echo "Correct!"
        return 0
    else
        echo "Incorrect!"
        return 1
    fi
}

# Function to play a level
function play_level() {
    local -n modules=$1
    local time_limit=$2

    for module in "${!modules[@]}"; do
        echo -e "\n=== ${modules[$module]} ==="
        
        # Run the module based on its name
        case $module in
            color) color_module ;;
            math) math_module ;;
            sequence) sequence_module ;;
            riddle) riddle_module ;;
            cipher) cipher_module ;;
            pattern) pattern_module ;;
            word) word_module ;;
        esac

        # Check the result
        if [ $? -eq 0 ]; then
            echo "Module solved!"
            ((modules_solved++))
        else
            echo "Strike!"
            ((strikes++))
        fi

        # Check win/lose conditions
        if [ $strikes -ge $MAX_STRIKES ]; then
            echo -e "\nGame Over! You've made too many mistakes."
            exit 1
        fi
    done
}

# Main game
echo -e "\nStarting Level 1"
play_level LEVEL1_MODULES $TIME_LIMIT_LEVEL1

echo -e "\nStarting Level 2"
play_level LEVEL2_MODULES $TIME_LIMIT_LEVEL2

echo -e "\nStarting Level 3"
play_level LEVEL3_MODULES $TIME_LIMIT_LEVEL3

# Final win message
if [ $modules_solved -eq $(( ${#LEVEL1_MODULES[@]} + ${#LEVEL2_MODULES[@]} + ${#LEVEL3_MODULES[@]} )) ]; then
    echo -e "\nCongratulations! You've defused all modules and completed all levels!"
else
    echo -e "\nTime's up! You failed to defuse the bomb."
fi

#!/bin/bash

# Check for help flag
if [[ $1 == "--help" || $1 == "-h" ]]; then
    echo "========== Defuse the Bomb Game - Help Menu =========="
    echo "Welcome to the 'Defuse the Bomb' game!"
    echo
    echo "Objective:"
    echo "   Solve puzzles in a limited time to defuse the bomb. Each incorrect answer or timeout adds a 'strike.'"
    echo "   Accumulating 3 strikes will result in a game over. Complete all levels to win!"
    echo
    echo "How to Play:"
    echo "   - The game consists of multiple levels, each with different types of puzzles."
    echo "   - Each level has its own time limit and a series of puzzles. Answer within the time limit to avoid a strike."
    echo "   - The game automatically advances to the next level when you solve all puzzles in the current level."
    echo
    echo "Command-Line Options:"
    echo "   --help, -h           Show this help menu."
    echo "   --no-color           Disable color output (useful for accessibility)."
    echo
    echo "Accessibility Features:"
    echo "   - Keyboard-only gameplay: You can play entirely using keyboard input."
    echo "   - Text-based interface for screen reader compatibility."
    echo "   - No need for internet access; the game runs entirely in your terminal."
    echo
    echo "Instructions to Start the Game:"
    echo "   1. Ensure the script is executable with the following command:"
    echo "         chmod +x ktane_game.sh"
    echo "   2. Run the game with:"
    echo "         ./ktane_game.sh"
    echo "   3. Follow the on-screen prompts to solve puzzles."
    echo
    echo "Additional Tips:"
    echo "   - Read each puzzle carefully before entering an answer."
    echo "   - If you fail to answer within the time limit, it counts as a strike."
    echo "   - To exit the game early, press Ctrl + C."
    echo
    echo "Good luck and enjoy the game!"
    echo "======================================================"
    exit 0
fi

