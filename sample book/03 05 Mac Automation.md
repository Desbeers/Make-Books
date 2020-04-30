# Automation on the Mac

Even thought the Terminal is damn cool in my opinion, it is not very *Mac* like. While I don’t mind to spend my time in the Terminal, most people seems to be a bit scared of it. A Mac would not be a Mac if we can simplify this book stuff...

## How wrong can you be?

Well, a Mac is not *the* Mac anymore nowadays, sad but true. Cupertino is turning our beloved Macs more and more into a Fort Knox. Gatekeeper they call it; a very appropriate name. And, in general, it’s for the good. Our Mac’s got a lot safer over the years.

Maybe a bit too safe for hobby-hackers like me. Catalina is pretty unhappy I’m running smart-ass scripts from my home directory. Catalina should be happy instead! I know very well how to run this stuff from *outside* my home directly but I try to be a good Mac citizen. So, up to now, I’m only a bit naughty. Just a bit and it is tolerated. For now...

## Meet my Workflow

Fancy Pancy, nowadays its very easy to make Automation Workflows. Every Mac even has an Application to make them; `Automator`. Super cool; click, click, click and I had a `Workflow` to run my scripts I thought...

### NOT!

Gatekeeper told me to ****-off; the door between my scrips and my workflow was hermetic closed.

> “YOU WILL NOT RUN SCRIPTS WITHIN YOUR OWN HOME DIRECTORY, YOU NAUGHTY BOY!”

## Then meet my Application?

Ok; I didn’t get it to work but I had some more tricks on my sleeve. What if I make a Automator `Application` instead of a `Workflow`? Will that work? After I open it and gave permission to sniff my *documents* folder? Will that open the Gate?

### Oh, yeh! That works!

We are one step closer. We have a working Application that’s not crying too much. So far, so good. But *not* good enough I want to have such fancy Workflow button in my Finder sidebar!

## Maybe my Workflow can date my Application?

Hehehe, yes it can! My Workflow will receive files from the Finder and send them to my Application. My Application will run the scrips. Mission completed!

---

Sometimes I feel myself so unbelievable cool!





