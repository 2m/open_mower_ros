# Do not abort current behaviour after emergency is cleared #65
# https://github.com/ClemensElflein/open_mower_ros/pull/65
gh pr diff --patch 65 | git am

# "Start in area" service implementation #66
# https://github.com/ClemensElflein/open_mower_ros/pull/66
gh pr diff --patch 66 | git am

# Fix for building paths with polygons that are too far away. #3
# https://github.com/ClemensElflein/slic3r_coverage_planner/pull/3
git cherry-pick ..fix/far-polygons-2m

