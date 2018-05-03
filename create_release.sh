

#!/bin/bash

echo "This is all target you can choose to use:";

branches=($(git remote show origin | grep "\w*\s*(new|tracked)" -E | awk -F" " '{print $1}'));

for (( i=0; i < ${#branches[@]}; i++)); do

	echo $i ":" ${branches[i]}

done

# Choose target to make release
read -p "Input index of target that you want:" n;

target=${branches[$n]};

echo $target

# Update all of tags from your repo

git fetch --tags --all

#get highest tag number

#VERSION=`git describe --abbrev=0 --tags` # The latest tags on current branch

count_tag=$(git ls-remote --tags origin | wc -l)

if ((count_tag != 0)); then

	VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)

	echo "Latest version tag: $VERSION"

		#replace . with space so can split into an array
	VERSION_BITS=(${VERSION//./ })

	#get number parts and increase last one by 1

	VNUM1=${VERSION_BITS[0]}
	echo $VNUM1
	VNUM2=${VERSION_BITS[1]}
	VNUM3=${VERSION_BITS[2]}
	VNUM3=$((VNUM3+1))

	#create new tag
	NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

else
	VERSION="version1.0.0"
	echo "This is the first version tag: $VERSION"
	VERSION_BITS=(${VERSION//./ })
	${VERSION_BITS[0]}=1
	${VERSION_BITS[1]}=0
	${VERSION_BITS[2]}=0
	VNUM1=${VERSION_BITS[0]}
	VNUM2=${VERSION_BITS[1]}
	VNUM3=${VERSION_BITS[2]}
	NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

fi
	
echo "Updating $VERSION to $NEW_TAG"

temp="Release of $NEW_TAG";

#read -p "Do you want keep default body for release?(Y/n)" answer;

read -p "Do you want keep default body for release?(Y/n)"

echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    	read -p "Input the content that you want to show in your realease:" content;

	body=$content;
else
	
	body="This is release for $NEW_TAG";

fi

API_JSON=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "Project_%s_TuyetNguyen","body": "%s","draft": false,"prerelease": false}' $NEW_TAG $target $NEW_TAG "$body")

echo $API_JSON

curl --data "$API_JSON" https://api.github.com/repos/yuki-nguyen/create_release/releases?access_token=133e772d0c947aeeffb8e347d7ee882c7bf09bd7 



