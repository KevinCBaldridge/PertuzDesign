<ROSETTASCRIPTS>
	<SCOREFXNS>
	<ScoreFunction name="ref2015" weights="ref2015"/>
	</SCOREFXNS>
	<MOVERS>
	<InterfaceAnalyzerMover name="IAref" scorefxn="ref2015"
	pack_separated="true" pack_input="true"
	resfile="false" packstat="true"
	interface_sc="true"
	fixedchains="H,L" />
	</MOVERS>
	<PROTOCOLS>
	<Add mover_name="IAref" />
	</PROTOCOLS>
</ROSETTASCRIPTS>
