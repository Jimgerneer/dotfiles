function review-clear --description "Delete the last PR review output"
    set review_file /tmp/review-output.md

    if test -f $review_file
        rm -f $review_file
        echo "Deleted $review_file"
    else
        echo "No review file to clear"
    end
end
