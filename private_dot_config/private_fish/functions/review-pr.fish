function review-pr --description "Review a GitHub PR using Claude Code review agent"
    if test (count $argv) -eq 0
        echo "Usage: review-pr <pr-number>"
        return 1
    end

    set pr_number $argv[1]
    set repo_root (git rev-parse --show-toplevel 2>/dev/null)

    if test -z "$repo_root"
        echo "Not in a git repository"
        return 1
    end

    bash ~/.config/fish/scripts/review-pr-worker.sh $pr_number $repo_root
end
