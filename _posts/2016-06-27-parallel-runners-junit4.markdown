---
layout: post
title:  "Parallel runners for Junit 4"
date:   2016-06-27 13:37:00 +0200
categories: java
---
Sometimes the capability of running [JUnit][junit] tests in parallel is very handy. When you have a lot of tests which don't interfere with each other, you can cut the execution time of the whole suite as many times as many processor cores you have available. Although JUnit itself does not provide support for parallel test execution, there are several ways to achieve this.

The first solution that springs to mind is using [Maven's][maven] Surefire plugin. It has great support for [running JUnit tests][surefire-junit] either in concurrent threads or even in separate JVM processes. However, it is possible to run JUnit tests in parallel without Maven by subclassing standard runners.

Starting with JUnit 4.7, the runners that descend from [`ParentRunner`][parentrunner], including [`BlockJUnit4ClassRunner`][blockjUnit4classrunner], [`Suite`][suite] and [`Parameterized`][parameterized], use a [`RunnerScheduler`][runnerscheduler] to schedule their child tests (such as test methods for BlockJUnit4ClassRunner).

The `RunnerScheduler` interface has two methods:

 * `schedule(Runnable childStatement)` is called by the `ParentRunner` to pass the child test which has to be run (either immediately or sometime later at discretion of the scheduler). It is called once for each child test.
 * `finished()` is called to notify the scheduler that all the children have been scheduled and no more will be incoming. It is called only once per parent runner.

Note that the parent runner will proceed to checking the test results immediately after `finished()` returns, regardless of whether child tests are completed yet. Since the default scheduler runs the child tests synchronously right when they are scheduled, this does not pose a problem. However, if we are to make a parallel scheduler, it's implementation of `finished()` should block until all the child tests are completed.

Using the custom scheduler is simple --- you just need to inject it into the parent runner by calling its method [`setScheduler(RunnerScheduler)`][setscheduler]. Because JUnit creaties runner instances using reflection, you'll still need to define a custom subclass of your runner and override its constructor. The following example shows how to do it for `BlockJUnit4ClassRunner`, although it can be done the same way for any runner that extends `ParentRunner`, including `Parameterized` and `Suite`.

{% highlight java %}
class BlockJUnit4ClassRunner extends org.junit.runners.BlockJUnit4ClassRunner {
	public BlockJUnit4ClassRunner(Class<?> klass)
			throws InitializationError {
		super(klass);
		this.setScheduler(new ParallelRunnerScheduler());
	}	
}
{% endhighlight %}

Note that any objects that are shared between individual child tests (e. g. those defined by [`@ClassRule`][classrule]) *must be thread safe.*

An example project with an implementation of the parallel scheduler and an example of its usage is available [on GitHub][example-github].

Both test suites and individual test cases can still be launched by any application that can launch JUnit tests (e. g. Eclipse or IntelliJ IDEA). Unfortunately, both Eclipse or IntelliJ IDEA display the test results erroneously. Eclipse assigns _all_ failure causes to the first test that failed, showing the rest of failed tests as successful; IntelliJ IDEA may display duplicate entries for test cases and test suites. Regardless, in both cases the tests itself are executed correctly and each test failure can be identified. Maven displays the results correctly, but if Maven is available, you may be better off parallellizing test with the Surefire plugin.

[junit]:http://junit.org/junit4/
[maven]:https://maven.apache.org/
[surefire-junit]:https://maven.apache.org/surefire/maven-surefire-plugin/examples/fork-options-and-parallel-execution.html
[parentrunner]:http://junit.org/junit4/javadoc/latest/org/junit/runners/ParentRunner.html
[blockjUnit4classrunner]:http://junit.org/junit4/javadoc/latest/org/junit/runners/BlockJUnit4ClassRunner.html
[suite]:http://junit.org/junit4/javadoc/latest/org/junit/runners/Suite.html
[parameterized]:http://junit.org/junit4/javadoc/latest/org/junit/runners/Parameterized.html
[runnerscheduler]:http://junit.org/junit4/javadoc/latest/org/junit/runners/model/RunnerScheduler.html
[setscheduler]:http://junit.org/junit4/javadoc/latest/org/junit/runners/ParentRunner.html#setScheduler(org.junit.runners.model.RunnerScheduler)
[example-github]:https://github.com/odisseus/junit-parallel-runners
[classrule]:http://junit.org/junit4/javadoc/latest/org/junit/ClassRule.html

