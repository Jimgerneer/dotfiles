function review-open --description "Open the last PR review output in nvim"
    set review_file /tmp/review-output.md

    if test -f $review_file
        nvim $review_file
    else
        echo "No review file found at $review_file"
        return 1
    end
end
