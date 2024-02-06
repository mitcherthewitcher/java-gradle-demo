# Java Gradle Java APM Testing

+ `brew install java` don't forget to symlink
+ `java --version` should return something
+ `brew install gradle`
+ Following [this guide](https://docs.gradle.org/current/samples/sample_building_java_applications.html#what_youll_build)

## Misc
+ From project root, build with `./gradlew build`
+ Run with
```
java -Ddd.trace.config=ddtrace.properties -javaagent:dd-java-agent.jar -jar app/build/libs/app.jar
```

+ Also tested adding property to command directly
```
java -Ddd.trace.sampling.rules='[{\"service\": \"my-service\", \"sample_rate\":0.2}]' -javaagent:dd-java-agent.jar -jar app/build/libs/app.jar
```
