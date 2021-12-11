#!/bin/bash -e
#if [ -f ~/ForgeryTools.jar ]; then
#       canforgery=1
#else
#       echo "Forgery tools not found. As of the time of writing, the Forgery tooling is not public."
        echo "Forgery does not yet support 1.17."
        echo "Performing a Fabric build only."
        echo
        canforgery=0
#fi
rm -rf build/libs
echo Building for Fabric...
./gradlew build
rm build/libs/*-dev.jar
artifact=$(echo build/libs/*.jar)
mv "$artifact" $(echo "$artifact" |sed 's/-/-Fabric-1.17-/' |sed 's/drogtor/Drogtor/')
if [ "$canforgery" == "1" ]; then
	cd forgery
	echo Building Forgery runtime...
	./gradlew build
	cd ..
	fabric=$(echo build/libs/Drogtor-Fabric*.jar)
	forge=$(echo "$fabric" | sed "s/Fabric/Forge/")
	echo Running Forgery...
	java -jar ~/ForgeryTools.jar "$fabric" "$forge" ~/.gradle/caches/fabric-loom/mappings/intermediary-1.16.4-v2.tiny ~/.gradle/caches/forge_gradle/minecraft_repo/versions/1.16.4/mcp_mappings.tsrg ./forgery/build/libs/forgery.jar ~/.gradle/caches/fabric-loom/minecraft-1.16.4-intermediary-net.fabricmc.yarn-1.16.4+build.6-v2.jar com.unascribed.drogtor
fi
echo Done
