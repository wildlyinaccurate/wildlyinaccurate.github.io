---
layout: post
title: Custom Doctrine 2 Console Commands
date: 2010-10-04 19:10:56.000000000 +01:00
categories:
- CodeIgniter
- Doctrine
- PHP
- Web Development
tags:
- commands
- console
- doctrine 2
status: publish
type: post
published: true
author: Joseph Wynn
---

_This post assumes you have set up [Doctrine 2 with CodeIgniter 2](http://eryr.wordpress.com/2010/09/26/integrating-doctrine-2-with-codeigniter-2/)._

## Load Data from Fixtures

I could not find a command to load data from fixtures, so I made a very basic command that recursively executes native SQL. If you want to load data from YAML files, you will need to search elsewhere for a YAML interpreter or even a way to convert YAML to SQL.

<!--more-->

In application/doctrine.php, add the following line anywhere after the chdir() command. Mine sits on line #5.

<pre>require_once '../fixtures/Commands.php';</pre>

And anywhere in the `$cli->addCommands` array, add: `new \Doctrine\ORM\Tools\Console\Command\LoadDataCommand(),`

Now create the following directories and files:{% image src: /assets/capture.jpg "Fixtures Directory Structure" alt: "" %}

application/fixtures/

application/fixtures/Commands.php

application/fixtures/Command/

application/fixtures/Command/LoadDataCommand.php

application/fixtures/Commands.php is used to load our custom commands. For now, we only have one command - LoadData. To load this command, simply add the line `require_once 'Command/LoadDataCommand.php';`

Now in application/fixtures/Command/LoadDataCommand.php, copy the following code:

<pre class="brush: php">&lt;?php
namespace Doctrine\ORM\Tools\Console\Command;

use Symfony\Component\Console\Input\InputArgument,
    Symfony\Component\Console\Input\InputOption,
    Symfony\Component\Console,
    Doctrine\ORM\Tools\Console\MetadataFilter,
    Doctrine\ORM\Tools\EntityGenerator,
    Doctrine\ORM\Tools\DisconnectedClassMetadataFactory;

class LoadDataCommand extends Console\Command\Command
{
    /**
     * @see Console\Command\Command
     */
    protected function configure()
    {
        $this
        -&gt;setName('load-data')
        -&gt;setDescription(
            'Find and run all SQL files in the fixtures directory.'
        )
        -&gt;setDefinition(array(
            new InputArgument(
                'fixtures-path', InputArgument::OPTIONAL,
                'The path to the fixtures directory. If none is provided, the default (application/fixtures) will be used.'
            )
        ))
        -&gt;setHelp(&lt;&lt;&lt;EOT
Processes the schema and either create it directly on EntityManager Storage Connection or generate the SQL output.
EOT
        );
    }

    /**
     * @see Console\Command\Command
     */
    protected function execute(Console\Input\InputInterface $input, Console\Output\OutputInterface $output)
    {
        $em = $this-&gt;getHelper('em')-&gt;getEntityManager();

        // Process destination directory
        if (($fixtures_path = $input-&gt;getArgument('fixtures-path')) === null) {
            $fixtures_path = dirname(getcwd()) . '/fixtures';
        }
        $fixtures_path = realpath($fixtures_path);

        if ( ! is_dir($fixtures_path)) {
            throw new \InvalidArgumentException(
                sprintf("Fixtures directory '&lt;info&gt;%s&lt;/info&gt;' does not exist.", $fixtures_path)
            );
        }

        $counter = 0;
        $rsm = new \Doctrine\ORM\Query\ResultSetMapping;

        foreach (glob("{$fixtures_path}/*.sql") as $filename)
        {
        	$output-&gt;write('Found file ' . basename($filename) . '.' . PHP_EOL);
        	$sql = file_get_contents($filename);
        	$output-&gt;write('Loading ' . basename($filename) . '... ' . PHP_EOL);

        	try
        	{
        		$errors = FALSE;
        		$em-&gt;createNativeQuery($sql, $rsm)-&gt;execute();
        	}
        	catch (\PDOException $e)
        	{
        		$output-&gt;write(PHP_EOL . "\t \tError!\t");
        		$output-&gt;write('Caught a PDOException. (' . $e-&gt;getMessage() . ')' . PHP_EOL);
        		$output-&gt;write("\t \tAttempting to recover... ");

        		if (is_numeric($e-&gt;getCode()))
        		{
        			$errors = TRUE;
        			$output-&gt;write('Unable to recover. ' . basename($filename) . ' was not fully loaded.');
        		}
        		else
        		{
        			$output-&gt;write('Recovery successful!');
        		}

        		$output-&gt;write(PHP_EOL . PHP_EOL);
        	}

        	if (! $errors)
        	{
        		$output-&gt;write('Successfully loaded ' . basename($filename) . '!' . PHP_EOL . PHP_EOL);
	        	$counter++;
        	}
        }

        $output-&gt;write("Finished loading data ({$counter} files processed)" . PHP_EOL);

    }
}</pre>

Now all you need to do is create .sql files in application/fixtures and run the load-data command from the Doctrine Console. Note that on my system, the script catches a PDOException after it executes a SQL file. I can't work out where the exception is coming from but the script still manages to process all of the files so you can safely ignore it.
