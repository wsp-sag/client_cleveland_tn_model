
Macro "Cleveland Model Version"
    project_version_number = 2
    required_tc_version = 384
    return({project_version_number, required_tc_version})
endMacro

DBox "Cleveland Model"
    right, center toolbox NoKeyboard
    title: "Cleveland Model"

    init do
        Shared  project_dbox, scenario_dbox, ui_file, scenario_file, scen_data_dir, project_name, prj_version, Args, loop, fiterations, ScenArr, ScenSel

// open up the .ini file in the TransCAD directory that lists where the model directory is and where the
// TransCAD directory is        
        {mod_file, ui_file, scenario_file, scen_data_dir} = RunMacro("TCP Get Project Files", "cleveland_config.ini", &errMsg)
        if mod_file = null then do ShowMessage(errMsg) return() end
        modinfo = GetFileInfo(mod_file)
        sceninfo = GetFileInfo(scenario_file)
					
        loop = 0
        final_loop = 0
        project_name = "Cleveland Model"
        {MacroInfo, Args, Opts, VarInfo} = RunMacro("TCP Read Planning Model", mod_file, scen_data_dir)
        {StepMacro, StepTitle, StepFlag} = MacroInfo
        StageName = Args[1]
        stages = StageName.length
        single_stage = 1
		
// load all scenarios

        RunMacro("TCP Run All Steps", &do_all_steps, &StepFlag)

        if !RunMacro("TCP Update Scenarios in Project Dbox", scenario_file, &ScenArr, &ScenSel, &ScenNames, stages, 0, Args) then
            return()
	
//        Runmacro("update spinner")

        fiter = {0,1,2,3,4,5,6,7,8,9,10}
        fval = "0"
        fiterations = 0
        project_dbox = 1
        
        // Set the mode radio list (stop after stage vs run all steps)
        modelMode = 1
    enditem

    update do
        if project_dbox = -99 then
            runmacro("closing")
        else do
            if !RunMacro("TCP Update Scenarios in Project Dbox", scenario_file, &ScenArr, &ScenSel, &ScenNames, stages, 1, Args) then
                Return()
            // Runmacro("update spinner")
            end
    endItem

// if you quit, run the closing macro
    close do Runmacro("closing") endItem

// load the graphic
    button  8,0
    icons: "bmp\\cleveland.bmp", "bmp\\cleveland.bmp"

    frame 0.5, 6, 41, 7.4 prompt: "Scenarios"

	// show a list of scenarios
    Scroll List 1.5, 7.0, 38.5, 3.5 multiple list: ScenNames variable: ScenSel do
        RunMacro("TCP Save Scenario File", ScenArr, ScenSel, scenario_file)
        RunMacro("TCP Update Scenarios Show Array", ScenArr, ScenSel, stages)
    endItem
    
    // Kyle - changing these to radio buttons to lessen confusion
    // checkbox "stops" 2, 10.9, 15 variable: single_stage prompt: "Stop after stage"
    // checkbox "all steps" Same, 12.1, 15 variable: do_all_steps prompt: "Run all steps" do
        // RunMacro("TCP Run All Steps", &do_all_steps, &StepFlag)
    // endItem
    Radio List 1.5,10.2,19,3 Variable: modelMode
    Radio Button 2,10.9 Prompt: "Stop After Stage" do
        single_stage = 1
        do_all_steps = 0
    enditem
    Radio Button 2,12 Prompt: "Run All Steps" do
        single_stage = 0
        do_all_steps = 1
        RunMacro("TCP Run All Steps", &do_all_steps, &StepFlag)
    enditem
    
	
// setup button
    button 25, 11.3, 13, 1.5 prompt: "Setup" do
        RunDbox("TCP Scenario dBox", scenario_file, scen_data_dir,, Args)
    enditem

//  Prepare Network button
    button 1,    17 icons: "bmp\\plannetwork.bmp", "bmp\\plannetwork.bmp" do cur_stage = 1  Runmacro("set steps") enditem
    button "tr1" After, Same, 20, 2 prompt:StageName[1]  do cur_stage = 1  Runmacro("run stages") enditem

// create network button "bmp\\plantripgen.bmp"
    button 1, After icons: "bmp\\planskim.bmp", "bmp\\planskim.bmp" do cur_stage = 2  Runmacro("set steps") enditem
    button "tr2" After, Same, 20, 2 prompt:StageName[2]  do cur_stage = 2  Runmacro("run stages") enditem

// Trip generation button "bmp\\plantripdist.bmp"
    button 1, After icons: "bmp\\plantripgen.bmp", "bmp\\plantripgen.bmp" do cur_stage = 3  Runmacro("set steps") enditem
    button "tr3" After, Same, 20, 2 prompt:StageName[3]  do cur_stage = 3  Runmacro("run stages") enditem

//  trip distribution button"bmp\\planmodesplit.bmp" 
    button 1, After icons: "bmp\\planmatrix.bmp", "bmp\\planmatrix.bmp" do cur_stage = 4  Runmacro("set steps") enditem
    button "tr4" After, Same, 20, 2 prompt:StageName[4]  do cur_stage = 4  Runmacro("run stages") enditem

// mode split button "bmp\\planmatrix.bmp"
    button 1, After icons: "bmp\\planmodesplit.bmp", "bmp\\planmodesplit.bmp" do cur_stage = 5  Runmacro("set steps") enditem
    button "tr5" After, Same, 20, 2 prompt:StageName[5]  do cur_stage = 5  Runmacro("run stages") enditem

// commercial vehicles button
    button 1, After icons: "bmp\\truck41.bmp", "bmp\\truck41.bmp" do cur_stage = 6  Runmacro("set steps") enditem
    button "tr6" After, Same, 20, 2 prompt:StageName[6]  do cur_stage = 6  Runmacro("run stages") enditem
	
// external trips button
    button 1, After icons: "bmp\\plantripdist.bmp", "bmp\\plantripdist.bmp" do cur_stage = 7  Runmacro("set steps") enditem
    button "tr7" After, Same, 20, 2 prompt:StageName[7]  do cur_stage = 7  Runmacro("run stages") enditem

// time of day button
    button 1, After icons: "bmp\\feedback1.bmp", "bmp\\feedback1.bmp" do cur_stage = 8  Runmacro("set steps") enditem
    button "tr8" After, Same, 20, 2  prompt:StageName[8]  do cur_stage = 8  Runmacro("run stages") enditem
 
// traffic assignment button
    button 1, After icons: "bmp\\planassign.bmp", "bmp\\planassign.bmp" do cur_stage = 9  Runmacro("set steps") enditem
    button "tr8" After, Same, 20, 2 prompt:"Traffic Assignment"  do cur_stage = 9  Runmacro("run stages") enditem

// quit button
    button     1, 40, 40, 1.6  prompt: "Quit"      do Runmacro("closing") enditem

    text  35, After Variable: "ver 0" + i2s(prj_version)

// sets the steps you wish to run
    macro "set steps" do
        SetAlternateInterface()
        RunMacro("TCP Set Steps", StepTitle[cur_stage], &StepFlag[cur_stage])

        do_all_steps = null
        RunMacro("TCP Run All Steps", &do_all_steps, &StepFlag)
        enditem

// runs the steps
    macro "run stages" do

        RunMacro("TCP Run Stages", cur_stage, single_stage, StepMacro, StepFlag, ScenArr, ScenSel, )
    endItem

// closes the dialog box
    macro "closing" do
        if RunMacro("TCP Close Project Dbox") = 1 then
            return()
    endItem


EndDbox



Macro "Prepare Network" (Args)
	
	// CreateMap

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
		
	// create a new report or delete an already existing one

	rpt = OpenFile(report_file, "a")
	
	WriteLine(rpt, "___________________________________________________________________________________________________________")
	WriteLine(rpt, "                                                            ")
	WriteLine(rpt, "                                              MODEL RESULTS                        ")
	WriteLine(rpt, "                                                            ")
	WriteLine(rpt, "___________________________________________________________________________________________________________")
	WriteLine(rpt, "                                                            ")	
	
	

	highway_proj = Args.[BY_HIGHWAY]
	cc = GetDBInfo(highway_proj)
	newMap = CreateMap("newMapName", {{"Scope", cc[1]}, {"Auto Project", "True"}})
	baselayers = GetDBLayers(highway_proj)

	node_layer = AddLayer(newMap, baselayers[1], highway_proj, baselayers[1])
	link_layer = AddLayer(newMap, baselayers[2], highway_proj, baselayers[2])
	
	SetLayer(node_layer)
	field_info = GetTableStructure(node_layer)
	mandatory_node_fields = {"ID", "Longitude", "Latitude", "Centroid"}
	
	inputDataProblem = "no"
	for i =1  to mandatory_node_fields.length do 
		field_missing = "yes"
		
		for j =1 to field_info.length do 
			if field_info[j][1] = mandatory_node_fields[i] then field_missing = "no"
		end 
		
		if field_missing = "yes" then do
			WriteLine(rpt, "The following field is missing from the Node Layer: " + mandatory_node_fields[i])
			inputDataProblem = "yes"
		end
			
	end	
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end
	
	SetLayer(link_layer)
	
	field_info = GetTableStructure(link_layer)
	
	// Check that all the field names are there 	
	mandatory_fields = {"Posted Speed", "FACTYPE_CD", "DIVIDED_CD", 
		"AB Lanes", "BA Lanes", /*"FUNCL_CD",*/ "AB_CAPPHPL", "BA_CAPPHPL", 
		"AB_AMCAP", "BA_AMCAP", "AB_MDCAP", "BA_MDCAP", "AB_PMCAP", "BA_PMCAP","AB_OPCAP", "BA_OPCAP", 
		"AB Initial Time", "BA Initial Time", "AB HBWGC", "BA HBWGC", "AB HBOGC", "BA HBOGC", "AB NHBGC", "BA NHBGC",
		"Alpha", "AB Count", "BA Count", "DailyCount", "Screenline"}
	
	inputDataProblem = "no"
	for i =1  to mandatory_fields.length do 
		field_missing = "yes"
		
		for j =1 to field_info.length do 
			if field_info[j][1] = mandatory_fields[i] then field_missing = "no"
		end 
		
		if field_missing = "yes" then do 
			WriteLine(rpt, "The following field is missing from the Link layer: " + mandatory_fields[i])
			inputDataProblem = "yes"
		end
	end
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end
	

	vec_id       = getdatavector(link_layer+"|", "ID",)
	vec_factype_cd = getdatavector(link_layer+"|","FACTYPE_CD",)
	vec_ab_lanes = getdatavector(link_layer+"|", "AB Lanes",)
	vec_ba_lanes = getdatavector(link_layer+"|", "BA Lanes",)
	vec_dir  = getdatavector(link_layer+"|", "DIR",)
	vec_AB_initial_time = getdatavector(link_layer+"|", "AB Initial Time",)
	vec_BA_initial_time = getdatavector(link_layer+"|", "BA Initial Time",)
	vec_length = getdatavector(link_layer+"|", "LENGTH",)
	vec_post_spd = getdatavector(link_layer+"|", "Posted Speed",)
	//vec_funcl_cd = getdatavector(link_layer+"|", "FUNCL_CD",)	
	vec_ab_capacity = getdatavector(link_layer+"|","AB_CAPPHPL",)
	vec_ba_capacity = getdatavector(link_layer+"|","BA_CAPPHPL",)
	vec_divided_cd = getdatavector(link_layer+"|","DIVIDED_CD",)
    
    // Kyle 4-28-2014 Added support for terrain
    vec_terrain_cd = getdatavector(link_layer+"|","TERRAIN_CD",)
    
	vec_alpha = getdatavector(link_layer+"|", "Alpha",)
	vec_ab_hbwgc = getdatavector(link_layer+"|", "AB HBWGC",)
	vec_ba_hbwgc = getdatavector(link_layer+"|", "BA HBWGC",)
	vec_ab_hbogc = getdatavector(link_layer+"|", "AB HBOGC",)
	vec_ba_hbogc = getdatavector(link_layer+"|", "BA HBOGC",)
	vec_ab_nhbgc = getdatavector(link_layer+"|", "AB NHBGC",)
	vec_ba_nhbgc = getdatavector(link_layer+"|", "BA NHBGC",)	
	vec_ab_amcap = getdatavector(link_layer+"|", "AB_AMCAP",)
	vec_ba_amcap = getdatavector(link_layer+"|", "BA_AMCAP",)
	vec_ab_mdcap = getdatavector(link_layer+"|", "AB_MDCAP",)
	vec_ba_mdcap = getdatavector(link_layer+"|", "BA_MDCAP",)
	vec_ab_pmcap = getdatavector(link_layer+"|", "AB_PMCAP",)
	vec_ba_pmcap = getdatavector(link_layer+"|", "BA_PMCAP",)
	vec_ab_opcap = getdatavector(link_layer+"|", "AB_OPCAP",)
	vec_ba_opcap = getdatavector(link_layer+"|", "BA_OPCAP",)

// Check that two way links to ensure that number of lanes are 
// equal in both directions. Also check that the number of lanes 
// are greater than zero in one directional links.	
	inputDataProblem = "no"
	for i = 1 to vec_dir.length do
		// if you have a two directional link

		if vec_dir[i] = 1 then do 
			if not vec_ab_lanes[i] > 0 then do
				WriteLine(rpt, "Problem with link: " + i2s(vec_id[i]) + ". The number of lanes in the direction AB direction should be greater than zero")
				inputDataProblem = "yes"
				end
		end
		if vec_dir[i] = -1 then do 
			if not vec_ba_lanes[i] > 0 then do
				WriteLine(rpt, "Problem with link: " + i2s(vec_id[i]) + ". The number of lanes in the direction BA direction should be greater than zero")
				inputDataProblem = "yes"
				end
		end
	end
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end

/* // Kyle - not using this field 
// check the values of the FUNCL_CD field
// Table 9 page 29
	
	funcl_cd_valid = {99, 30, 20, 21, 22, 23, 24, 25, 10, 11, 12, 13, 14, 15, 16, 17, 19,
    1, 2, 6, 7, 8, 9}
	inputDataProblem = "no"
	for i = 1 to vec_funcl_cd.length do 
		foundMatch = "no"
		for j = 1 to funcl_cd_valid.length do
			if vec_funcl_cd[i] = funcl_cd_valid[j] then 
				foundMatch = "yes"
		end
		if foundMatch = "no" then do
			WriteLine(rpt, "Link: " + i2s(vec_id[i]) + " Invalid value in the FUNCL_CD field: " + i2s(vec_funcl_cd[i]) + "\n" + "Please look at Table 9 in the Procedures Manual for the valid values")
			inputDataProblem = "yes"
		end	
	end
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end		
*/	
	// check the values of the FACTYPE_CD variable
    // Kyle 4/28/2014 - Updated to add speed and terrain (and modify factype lookup)
    
	capacityLookup = OpenTable("capacityLookupView", "FFB", {Args.[Capacity]}, {{"Shared", "True"}})
    vec_factype_cd2 = getdatavector(capacityLookup+"|", "FACTYPE_CD",)
    vec_speed_cd2 = getdatavector(capacityLookup+"|", "SPEED",)
    vec_terrain_cd2 = getdatavector(capacityLookup+"|", "TERRAIN_CD",)
	vec_divided_cd2 = getdatavector(capacityLookup+"|", "DIVIDED_CD",)
	vec_r_capphpl2 = getdatavector(capacityLookup+"|", "R_CAPPHPL",)
	
	// check if the FACTYPE_CD values are valid
	inputDataProblem = "no"
	for i = 1 to vec_factype_cd.length do
		foundMatch = "no"
		for j = 1 to vec_factype_cd2.length do 
			if vec_factype_cd[i] = vec_factype_cd2[j] then do 
				foundMatch = "yes"
			end
		end
		if foundMatch = "no" then do 
			WriteLine(rpt, "Link: " + i2s(vec_id[i]) + " Invalid value in the FACTYPE_CD field: " + i2s(vec_factype_cd[i]))
			inputDataProblem = "yes"
		end
	end
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end	

	// check the values of the DIVIDED_CD variable 

	inputDataProblem = "no"	
	for i = 1 to vec_divided_cd.length do
		// Kyle 4/29/2014 - Changed to 0 and 1 values
        if vec_divided_cd[i] <> 0 and vec_divided_cd[i] <> 1 then do
			WriteLine(rpt, "Link: " + i2s(vec_id[i]) + " Invalid value in the DIVIDED_CD field: " + i2s(vec_divided_cd[i]) + "\n" + "Valid values for DIVIDED_CD are 0 and 1.")
			inputDataProblem = "yes"
		end
	end
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end	
	
	// Update the capacity from the capacity table 
	
	inputDataProblem = "no"
	for i = 1 to vec_ab_capacity.length do
		
		factype = vec_factype_cd[i]
		divided = vec_divided_cd[i]
        speed = vec_post_spd[i]
        terrain = vec_terrain_cd[i]
        
		matchFound = "no"
        
        // Kyle 4/29/2014 - All centroid connectors get 99,999
        if factype = 12 then do
            vec_ab_capacity[i] = 99999
            vec_ba_capacity[i] = 99999
            matchFound = "yes"
        end
        
		for j = 1 to vec_factype_cd2.length do 
			if vec_factype_cd2[j] = factype and vec_divided_cd2[j] = divided and vec_speed_cd2[j] = speed and vec_terrain_cd2[j] = terrain then do
				if vec_dir[i] = 1 or vec_dir[i] = 0 then vec_ab_capacity[i] = vec_r_capphpl2[j]
				if vec_dir[i] = 0 or vec_dir[i] = -1 then vec_ba_capacity[i] = vec_r_capphpl2[j]
				matchFound = "yes"
			end
		end
		if matchFound = "no" then do
			WriteLine(rpt, "Link: " + String(vec_id[i]) + " I could not find a match for FACTYPE_CD: " + String(factype)  
				+ ", DIVIDED_CD: " + String(divided) + ", SPEED: " + String(speed) + ", and TERRAIN_CD: " + String(terrain) + "  in the capacity table")
			inputDataProblem = "yes"
		end
	end
	if inputDataProblem = "yes" then do 
		ShowMessage("Problem with the input data. Please look at the log file")
		CloseFile(rpt)
		return(0)
	end	
	
	setdatavector(link_layer+"|", "AB_CAPPHPL", vec_ab_capacity,)
    setdatavector(link_layer+"|", "BA_CAPPHPL", vec_ba_capacity,)

	// Populate the Alpha field 
	alphaParameters = OpenTable("AlphaParameters", "FFB", {Args.[alpha Parameters]}, {{"Shared", "True"}})
	vec_input_factype = getdatavector(alphaParameters+"|", "FACTYPE_CD",)	
	vec_input_alpha   = getdatavector(alphaParameters+"|", "Alpha",)
	
	inputDataProblem = "no"
	for i = 1 to vec_alpha.length do
		for j = 1 to vec_input_alpha.length do 
			if vec_factype_cd[i] = vec_input_factype[j] then vec_alpha[i] = vec_input_alpha[j] 
		end
	end
	
	setdatavector(link_layer+"|", "Alpha", vec_alpha,)	

// Kyle 4/29/2014 - Now using a lookup table	
// Calculate the initial time field
    
    // Join the speed adjustment table to the link layer and collect speed adjustment vector
    dv_speedLookup = OpenTable("speedLookupView", "FFB", {Args.[Speed]}, {{"Shared", "True"}})
    a_masterfields = {link_layer + ".FACTYPE_CD"      ,link_layer + ".TERRAIN_CD"     }
    a_slavefields =  {dv_speedLookup + ".FACTYPE_CD"  ,dv_speedLookup + ".TERRAIN_CD" }
    dv_join = JoinViewsMulti("temp join",a_masterfields,a_slavefields,)
    vec_speedAdj = getdatavector(dv_join+"|", dv_speedLookup + ".SpeedAdj",)
    
    // Calculate initial time vectors
    vec_AB_initial_time = if (vec_dir = 1 or vec_dir = 0) then vec_length / (vec_post_spd + vec_speedAdj) * 60 else null
    vec_BA_initial_time = if (vec_dir = -1 or vec_dir = 0) then vec_length / (vec_post_spd + vec_speedAdj) * 60 else null
    
    // Close the joined view and speed adjustment table
    CloseView(dv_join)
    CloseView(dv_speedLookup)
    
    // Set initial time vectors into the link layer
    setdatavector(link_layer+"|","AB Initial Time", vec_AB_initial_time,)
	setdatavector(link_layer+"|","BA Initial Time", vec_BA_initial_time,)
    
    
// Kyle 4/29/2014 - Previous method.  Now using a lookup table	
/*
for i = 1 to vec_factype_cd.length do
		// case 1 AB
		if (vec_factype_cd[i] = 1 or (vec_factype_cd[i] = 2 and vec_divided_cd[i] = 2) or 
			(vec_factype_cd[i] = 3 and vec_divided_cd[i] = 2)) and 
			  (vec_dir[i] = 0 or vec_dir[i] = 1) then
			vec_AB_initial_time[i] = vec_length[i] / (vec_post_spd[i] + 5.0) * 60
		// case 1 BA
		if (vec_factype_cd[i] = 1 or (vec_factype_cd[i] = 2 and vec_divided_cd[i] = 2) or 
			(vec_factype_cd[i] = 3 and vec_divided_cd[i] = 2)) and 
			  (vec_dir[i] = 0 or vec_dir[i] = -1) then
			vec_BA_initial_time[i] = vec_length[i] / (vec_post_spd[i] + 5.0) * 60
		// case 2 AB
		if (vec_factype_cd[i] = 2 and (vec_divided_cd[i] = 1 or vec_divided_cd[i] = 3)) or 
		     (vec_factype_cd[i] = 3 and (vec_divided_cd[i] = 1 or vec_divided_cd[i] = 3)) or 
              (vec_factype_cd[i] > 3 and vec_factype_cd[i] < 8) and 
				(vec_dir[i] = 0 or vec_dir[i] = 1) then
			vec_AB_initial_time[i] = vec_length[i] / (vec_post_spd[i] - 5.0) * 60	
		// case 2 BA
		if (vec_factype_cd[i] = 2 and (vec_divided_cd[i] = 1 or vec_divided_cd[i] = 3)) or 
		     (vec_factype_cd[i] = 3 and (vec_divided_cd[i] = 1 or vec_divided_cd[i] = 3)) or 
              (vec_factype_cd[i] > 3 and vec_factype_cd[i] < 8) and 
				(vec_dir[i] = 0 or vec_dir[i] = -1) then
			vec_BA_initial_time[i] = vec_length[i] / (vec_post_spd[i] - 5.0) * 60
		// case 3 AB
		if (vec_factype_cd[i] = 12 or vec_factype_cd[i] = 8 or vec_factype_cd[i] = 10
			  or vec_factype_cd[i] = 11 or vec_factype_cd[i] = 9 or vec_factype_cd[i] = 13) and 
				(vec_dir[i] = 0 or vec_dir[i] = 1) then 
			vec_AB_initial_time[i] = vec_length[i] / vec_post_spd[i] * 60	
		// case 3 BA
		if (vec_factype_cd[i] = 12 or vec_factype_cd[i] = 8 or vec_factype_cd[i] = 10
			  or vec_factype_cd[i] = 11 or vec_factype_cd[i] = 9 or vec_factype_cd[i] = 13) and 
				(vec_dir[i] = 0 or vec_dir[i] = -1) then 
			vec_BA_initial_time[i] = vec_length[i] / vec_post_spd[i] * 60	
	end

	setdatavector(link_layer+"|","AB Initial Time", vec_AB_initial_time,)
	setdatavector(link_layer+"|","BA Initial Time", vec_BA_initial_time,)
*/

// calculate the link generalized cost
	
	a_hbwgc = Args.[Auto Operating Cost] / ( 0.5 * Args.[Average Wage Rate] / 60 )
	a_hbogc = Args.[Auto Operating Cost] / ( 0.25 * Args.[Average Wage Rate] / 60 )
	a_nhbgc = Args.[Auto Operating Cost] / ( 0.375 * Args.[Average Wage Rate] / 60 )
	
	for i = 1 to vec_AB_initial_time.length do
		if vec_dir[i] = 0 or vec_dir[i] = 1 then do
			vec_ab_hbwgc[i] = vec_AB_initial_time[i] + a_hbwgc * vec_length[i]
			vec_ab_hbogc[i] = vec_AB_initial_time[i] + a_hbogc * vec_length[i]
			vec_ab_nhbgc[i] = vec_AB_initial_time[i] + a_nhbgc * vec_length[i]
		end
		if vec_dir[i] = 0 or vec_dir[i] = -1 then do
			vec_ba_hbwgc[i] = vec_BA_initial_time[i] + a_hbwgc * vec_length[i]
			vec_ba_hbogc[i] = vec_BA_initial_time[i] + a_hbogc * vec_length[i]
			vec_ba_nhbgc[i] = vec_BA_initial_time[i] + a_nhbgc * vec_length[i]
		end
	end
	
	setdatavector(link_layer+"|", "AB HBWGC", vec_ab_hbwgc,)
	setdatavector(link_layer+"|", "BA HBWGC", vec_ba_hbwgc,)
	setdatavector(link_layer+"|", "AB HBOGC", vec_ab_hbogc,)
	setdatavector(link_layer+"|", "BA HBOGC", vec_ba_hbogc,)
	setdatavector(link_layer+"|", "AB NHBGC", vec_ab_nhbgc,)
	setdatavector(link_layer+"|", "BA NHBGC", vec_ba_nhbgc,)
	
	// Calculate values for time period capacity

	peakFactor_file = null
	if Args.[Area Type Code] = 1 then peakFactor_file = Args.[Peak Factors Small]
	if Args.[Area Type Code] = 2 then peakFactor_file = Args.[Peak Factors Large]
	if peakFactor_file = null then do
		ShowMessage("The Area Type Code variable should take the value one or two in the model_table.bin file")
		return(0)
	end 
	peakFactorTable = OpenTable("capacityLookupView", "FFB", {peakFactor_file}, {{"Shared", "True"}})
	vec_peak_factors = getdatavector(peakFactorTable+"|", "Factor",)	

	for i = 1 to vec_dir.length do
		// if you have a two directional link
		if vec_dir[i] = 0 or vec_dir[i] = 1 then do
			vec_ab_amcap[i] = vec_ab_capacity[i] * vec_ab_lanes[i] / vec_peak_factors[1]
			vec_ab_mdcap[i] = vec_ab_capacity[i] * vec_ab_lanes[i] / vec_peak_factors[2]
			vec_ab_pmcap[i] = vec_ab_capacity[i] * vec_ab_lanes[i] / vec_peak_factors[3]
			vec_ab_opcap[i] = vec_ab_capacity[i] * vec_ab_lanes[i] / vec_peak_factors[4]
		end
		if vec_dir[i] = -1 or vec_dir[i] = 0 then do 
			vec_ba_amcap[i] = vec_ba_capacity[i] * vec_ba_lanes[i] / vec_peak_factors[1]
			vec_ba_mdcap[i] = vec_ba_capacity[i] * vec_ba_lanes[i] / vec_peak_factors[2]
			vec_ba_pmcap[i] = vec_ba_capacity[i] * vec_ba_lanes[i] / vec_peak_factors[3]
			vec_ba_opcap[i] = vec_ba_capacity[i] * vec_ba_lanes[i] / vec_peak_factors[4]
		end
	end	
	
	setdatavector(link_layer+"|", "AB_AMCAP", vec_ab_amcap,)
	setdatavector(link_layer+"|", "BA_AMCAP", vec_ba_amcap,)
	setdatavector(link_layer+"|", "AB_MDCAP", vec_ab_mdcap,)
	setdatavector(link_layer+"|", "BA_MDCAP", vec_ba_mdcap,)
	setdatavector(link_layer+"|", "AB_PMCAP", vec_ab_pmcap,)
	setdatavector(link_layer+"|", "BA_PMCAP", vec_ba_pmcap,)
	setdatavector(link_layer+"|", "AB_OPCAP", vec_ab_opcap,)
	setdatavector(link_layer+"|", "BA_OPCAP", vec_ba_opcap,)	

	CloseMap(newMap)
	RunMacro("close everything")
		
	Return(1)
	quit:
		Return(0)	

	
endMacro

Macro "Create Network"  (Args)

	shared scen_data_dir 

	highway_proj = Args.[BY_HIGHWAY]
	turnpen = scen_data_dir + "\\Input\\turn_pen.bin"
	cc = GetDBInfo(highway_proj)
	newMap = CreateMap("newMapName", {{"Scope", cc[1]}, {"Auto Project", "True"}})
	baselayers = GetDBLayers(highway_proj)
	node_layer = AddLayer(newMap, baselayers[1], highway_proj, baselayers[1])
	link_layer = AddLayer(newMap, baselayers[2], highway_proj, baselayers[2])
	SetLayer(link_layer)
	
    RunMacro("TCB Init")
// STEP 1: Build Highway Network
	
     Opts = null
     Opts.Input.[Link Set] = link_layer
     Opts.Global.[Network Options].[Link Type] = {"FACTYPE_CD", "[" + link_layer + "].FACTYPE_CD", "[" + link_layer + "].FACTYPE_CD"}
     Opts.Global.[Network Options].[Node ID] = "[" + node_layer + "].ID"
     Opts.Global.[Network Options].[Link ID] = "[" + link_layer + "].ID"
     Opts.Global.[Network Options].[Turn Penalties] = "Yes"
     Opts.Global.[Network Options].[Keep Duplicate Links] = "FALSE"
     Opts.Global.[Network Options].[Ignore Link Direction] = "FALSE"
     Opts.Global.[Network Options].[Time Unit] = "Minutes"
     Opts.Global.[Link Options] = {{"Length", {"[" + link_layer + "].Length", "[" + link_layer + "].Length", , , "False"}}, {"[AB_AMCAP / BA_AMCAP]", {"[" + link_layer + "].AB_AMCAP", "[" + link_layer + "].BA_AMCAP", , , "False"}}, {"[AB_CAPPHPL / BA_CAPPHPL]", {"[" + link_layer + "].AB_CAPPHPL", "[" + link_layer + "].BA_CAPPHPL", , , "False"}}, {"[AB_MDCAP / BA_MDCAP]", {"[" + link_layer + "].AB_MDCAP", "[" + link_layer + "].BA_MDCAP", , , "False"}}, {"[AB_PMCAP / BA_PMCAP]", {"[" + link_layer + "].AB_PMCAP", "[" + link_layer + "].BA_PMCAP", , , "False"}}, {"[AB_OPCAP / BA_OPCAP]", {"[" + link_layer + "].AB_OPCAP", "[" + link_layer + "].BA_OPCAP", , , "False"}}, {"[[AB Initial Time] / [BA Initial Time]]", {"[" + link_layer + "].[AB Initial Time]", "[" + link_layer + "].[BA Initial Time]", , , "False"}}, {"[[AB HBWGC] / [BA HBWGC]]", {"[" + link_layer + "].[AB HBWGC]", "[" + link_layer + "].[BA HBWGC]", , , "False"}}, {"[[AB HBOGC] / [BA HBOGC]]", {"[" + link_layer + "].[AB HBOGC]", "[" + link_layer + "].[BA HBOGC]", , , "False"}}, {"[[AB NHBGC] / [BA NHBGC]]", {"[" + link_layer + "].[AB NHBGC]", "[" + link_layer + "].[BA NHBGC]", , , "False"}}, {"Alpha", {"[" + link_layer + "].Alpha", "[" + link_layer + "].Alpha", , , "False"}}}
     Opts.Global.[Length Unit] = "Miles"
     Opts.Global.[Time Unit] = "Minutes"
     Opts.Output.[Network File] = Args.[network] 
	

	
     ret_value = RunMacro("TCB Run Operation", "Build Highway Network", Opts, &Ret)
     if !ret_value then goto quit



//Network Settings (05/20/15)

     Opts = null
     Opts.Input.Database = highway_proj
     Opts.Input.Network = Args.[network] 
     Opts.Input.[Spc Turn Pen Table] = {turnpen}
     Opts.Global.[Global Turn Penalties] = {0, 0, 0, 0}
     Opts.Global.[Update Network Fields].Formulas = {}

     ret_value = RunMacro("TCB Run Operation", "Highway Network Setting", Opts, &Ret)

     if !ret_value then goto quit








	CloseMap(newMap)	 
	RunMacro("close everything")
	
	Return(ret_value)
    quit:
         Return(ret_value)

endMacro

Macro "Build Skims" (Args)
	
	shared scen_data_dir 

	highway_proj = Args.[BY_HIGHWAY]
	cc = GetDBInfo(highway_proj)
	newMap = CreateMap("newMapName", {{"Scope", cc[1]}, {"Auto Project", "True"}})
	baselayers = GetDBLayers(highway_proj)
	node_layer = AddLayer(newMap, baselayers[1], highway_proj, baselayers[1])
	link_layer = AddLayer(newMap, baselayers[2], highway_proj, baselayers[2])
	SetLayer(link_layer)
	
//	 ShowMessage("Done with the creation")
	
	 SetView(node_layer)
	
//	  ShowMessage("Calculate the HBW SPs")

	 hbw_mtx_file = Args.[HBWGC_PATH]	
	 highway_db = Args.[BY_HIGHWAY]
	 node_lyr = node_layer

	 RunMacro("TCB Init")
     Opts = null
     Opts.Input.Network = Args.[network]
     Opts.Input.[Origin Set] = {highway_db+"|"+node_lyr, node_lyr, "Centroids", "Select * where Centroid = 1"}
     Opts.Input.[Destination Set] = {highway_db+"|"+node_lyr, node_lyr, "Centroids"}
     //Opts.Input.[Via Set] = {highway_db+"|"+node_lyr, node_lyr}
	 
     Opts.Field.Minimize = "[[AB HBWGC] / [BA HBWGC]]"
     Opts.Field.Nodes = node_lyr+".ID"
	 
     Opts.Field.[Skim Fields] = {{"Length", "All"}, {"[[AB Initial Time] / [BA Initial Time]]", "All"}}
     Opts.Output.[Output Matrix].Label = "Shortest Path"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = hbw_mtx_file
     ret_value = RunMacro("TCB Run Procedure", 3, "TCSPMAT", Opts)
     if !ret_value then goto quit
	 

//	 ShowMessage("Calculate the HBO SPs")
	 
	 hbo_mtx_file = Args.[HBOGC_PATH] 
	 
     Opts = null
     Opts.Input.Network = Args.[network]
     Opts.Input.[Origin Set] = {highway_db+"|"+node_lyr, node_lyr, "Centroids", "Select * where Centroid = 1"}
     Opts.Input.[Destination Set] = {highway_db+"|"+node_lyr, node_lyr, "Centroids"}
     //Opts.Input.[Via Set] = {highway_db+"|"+node_lyr, node_lyr}
     Opts.Field.Nodes = node_lyr+".ID"	 
     Opts.Field.Minimize = "[[AB HBOGC] / [BA HBOGC]]"

     Opts.Field.[Skim Fields] = {{"Length", "All"}, {"[[AB Initial Time] / [BA Initial Time]]", "All"}}
     Opts.Output.[Output Matrix].Label = "Shortest Path"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = hbo_mtx_file // 

     ret_value = RunMacro("TCB Run Procedure", 3, "TCSPMAT", Opts)

//	  ShowMessage("Calculate the NHB SPs")
	 
	 nhb_mtx_file = Args.[NHBGC_PATH]
	 
     Opts = null
     Opts.Input.Network = Args.[network]
     Opts.Input.[Origin Set] = {highway_db+"|"+node_lyr, node_lyr, "Centroids", "Select * where Centroid = 1"}
     Opts.Input.[Destination Set] = {highway_db+"|"+node_lyr, node_lyr, "Centroids"}
     //Opts.Input.[Via Set] = {highway_db+"|"+node_lyr, node_lyr}
     Opts.Field.Nodes = node_lyr+".ID"		 
	 
     Opts.Field.Minimize = "[[AB NHBGC] / [BA NHBGC]]"
     Opts.Field.[Skim Fields] = {{"Length", "All"}, {"[[AB Initial Time] / [BA Initial Time]]", "All"}}
     Opts.Output.[Output Matrix].Label = "Shortest Path"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = nhb_mtx_file // 

     ret_value = RunMacro("TCB Run Procedure", 3, "TCSPMAT", Opts)
	 
     if !ret_value then goto quit

//	ShowMessage("Calculate Intrazonal Travel Time and Length for all the skim Matrices")
	
// Intrazonal Generalized cost 

     Opts = null
     Opts.Input.[Matrix Currency] = {hbw_mtx_file, "[[AB HBWGC] / [BA HBWGC]]", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1
	ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts)
 //    ret_value = RunMacro("TCB Run Procedure", "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit
		
	
// Intrazonal length 
     Opts = null
     Opts.Input.[Matrix Currency] = {hbw_mtx_file, "Length (Skim)", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit

// STEP 2: Intrazonal travel time
     Opts = null
     Opts.Input.[Matrix Currency] = {hbw_mtx_file, "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit	 
	 
//   Generalized Cost
     Opts = null
     Opts.Input.[Matrix Currency] = {hbo_mtx_file, "[[AB HBOGC] / [BA HBOGC]]", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit
	 
	 
// Intrazonal length 
     Opts = null
     Opts.Input.[Matrix Currency] = {hbo_mtx_file, "Length (Skim)", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit

// STEP 2: Intrazonal travel time
     Opts = null
     Opts.Input.[Matrix Currency] = {hbo_mtx_file, "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit	 

//   Generalized Cost
     Opts = null
     Opts.Input.[Matrix Currency] = {nhb_mtx_file, "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit	 
	 
// Intrazonal length 
     Opts = null
     Opts.Input.[Matrix Currency] = {nhb_mtx_file, "Length (Skim)", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure", 1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit

// STEP 2: Intrazonal travel time
     Opts = null
     Opts.Input.[Matrix Currency] = {nhb_mtx_file, "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.Factor = 0.75
     Opts.Global.Neighbors = 3
     Opts.Global.Operation = 1
     Opts.Global.[Treat Missing] = 1

     ret_value = RunMacro("TCB Run Procedure",1, "Intrazonal", Opts, &Ret)

     if !ret_value then goto quit		 
	 
	 CloseMap(newMap)
	
	RunMacro("close everything")
	Return(ret_value)
    quit:
         Return(ret_value )

endMacro

Macro "Apply Disaggregate Submodel" (Args)
	
	if Args.[Number of Internal Zones] = 0 then do 
		ShowMessage("The Number of Internal Zones Parameter Should be Equal To the Number of Internal Zones in the Socioeconomic Data Table")
		Return(0)
	end
	
	// Check that all the nesseary fields exist in the SE Data Table
	sedata = OpenTable("seData", "FFB", {Args.[SEDATA Table]}, {{"Shared", "True"}})

	field_info = GetTableStructure(sedata)
    mandatory_fields = {"HHPopulation","GQPopulation","Households","Vehicles","Industry","Retail","HwyRet","Service","Office","TotEmp","Students","CV1IND","CV2IND","CV3IND","CV1RET","CV2RET","CV3RET","CV1HWY","CV2HWY","CV3HWY","CV1SER","CV2SER","CV3SER","CV1OFF","CV2OFF","CV3OFF","hbwp","hbwa","hbop","hboa","hbschp","hbscha","nhbwp","nhbwa","nhbop","nhboa","cv1p","cv1a","cv2p","cv2a","cv3p","cv3a","ixp","ixa","CIterations","HHClosure","hhp1","hhp2","hhp3","hhp4","hhp5","hha0","hha1","hha2","hha3","hhp1a0","hhp1a1","hhp1a2","hhp1a3","hhp2a0","hhp2a1","hhp2a2","hhp2a3","hhp3a0","hhp3a1","hhp3a2","hhp3a3","hhp4a0","hhp4a1","hhp4a2","hhp4a3","hhp5a0","hhp5a1","hhp5a2","hhp5a3"}
	for i =1  to mandatory_fields.length do 
		field_missing = "yes"
		
		for j =1 to field_info.length do 
			if field_info[j][1] = mandatory_fields[i] then field_missing = "no"
		end 
		
		if field_missing = "yes" then do 
			ShowMessage("The following field is missing: " + mandatory_fields[i])
			Return(0)
		end 
	end
	CloseView(sedata)
	
	// Now appy the fratar algorithm 

	sefile = Args.[SEDATA Table]
	
	se = OpenTable("se", "FFB", {sefile})
    vhh = GetDataVector(se+"|","Vehicles",)

    dim se_SIZE[5],se_aut[4],HHLD[5,4],tmp_aut[4],tmp_size[5],ratioaut[4],ratiosize[5]

	CreateProgressBar("Household Distribution", "True")

	autos_dist = OpenTable("autos", "FFB", {Args.[AUTOS_DIST]})
	autos_dist_x = getDataVector(autos_dist+"|", "X",)
	autos_dist_y = getDataVector(autos_dist+"|", "Y",)
	autos_dist_z = getDataVector(autos_dist+"|", "Z",)
	autos_dist_c = getDataVector(autos_dist+"|", "Const",)

	hhsize_dist = OpenTable("hhsize_dist", "FFB", {Args.[HHSIZE_DIST]})
	
	hhsize_dist_x = getDataVector(hhsize_dist+"|", "X",)
	hhsize_dist_y = getDataVector(hhsize_dist+"|", "Y",)
	hhsize_dist_z = getDataVector(hhsize_dist+"|", "Z",)
	hhsize_dist_w = getDataVector(hhsize_dist+"|", "W",)

	joint_dist = OpenTable("joint_dist", "FFB", {Args.[JOINT_DIST]})
	
	jdist_a0 = getDataVector(joint_dist+"|", "Autos0",)
	jdist_a1 = getDataVector(joint_dist+"|", "Autos1",)
	jdist_a2 = getDataVector(joint_dist+"|", "Autos2",)
	jdist_a3 = getDataVector(joint_dist+"|", "Autos3",)
	
	SE_Set=se+"|"
	kk=0		
	// ShowMessage("Calculate Household Size and Vehicle Distributions")
	
    serec=GetFirstRecord(SE_Set,null)
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do 
			
			zone = se.TAZ
			hhs = se.Households
			pop = se.HHPopulation
			veh = se.Vehicles
			
		// households by size
		   if (hhs>0) then do
		    pphh = Min(Max(pop/hhs,1.0),3.5)
		    
		    pers1_sh =  hhsize_dist_x[1]*Pow(pphh,3) + hhsize_dist_y[1]*Pow(pphh,2) + hhsize_dist_z[1]*pphh + hhsize_dist_w[1]
		    pers2_sh =  hhsize_dist_x[2]*Pow(pphh,3) + hhsize_dist_y[2]*Pow(pphh,2) + hhsize_dist_z[2]*pphh + hhsize_dist_w[2]
		    pers3_sh =  hhsize_dist_x[3]*Pow(pphh,3) + hhsize_dist_y[3]*Pow(pphh,2) + hhsize_dist_z[3]*pphh + hhsize_dist_w[3]
		    pers4_sh =  hhsize_dist_x[4]*Pow(pphh,3) + hhsize_dist_y[4]*Pow(pphh,2) + hhsize_dist_z[4]*pphh + hhsize_dist_w[4]
		    pers5_sh =  hhsize_dist_x[5]*Pow(pphh,3) + hhsize_dist_y[5]*Pow(pphh,2) + hhsize_dist_z[5]*pphh + hhsize_dist_w[5]

		    se_SIZE[1] = Max(pers1_sh,0.0) * hhs
		    se_SIZE[2] = Max(pers2_sh,0.0) * hhs
	            se_SIZE[3] = Max(pers3_sh,0.0) * hhs
		    se_SIZE[4] = Max(pers4_sh,0.0) * hhs
		    se_SIZE[5] = Max(hhs - (se_SIZE[1] + se_SIZE[2] + se_SIZE[3] + se_SIZE[4]),0.0)
		   end  
		   else do 
		    se_SIZE[1] = 0.0
		    se_SIZE[2] = 0.0
		    se_SIZE[3] = 0.0
		    se_SIZE[4] = 0.0
		    se_SIZE[5] = 0.0
		   end
			
		// households by autos
	        if (hhs>0) then do
	         avaut = Min(Max(veh/hhs,0.50),2.50)
	        end
	        else do
	         avaut = 1.5
	        end
	                
		// Compute marginal shares of Households by auto ownership group
		auto0_sh =  autos_dist_x[1]*Pow(avaut,3) + autos_dist_y[1]*Pow(avaut,2) + autos_dist_z[1]*avaut + autos_dist_c[1]
		auto1_sh =  autos_dist_x[2]*Pow(avaut,3) + autos_dist_y[2]*Pow(avaut,2) + autos_dist_z[2]*avaut + autos_dist_c[2]
		auto2_sh =  autos_dist_x[3]*Pow(avaut,3) + autos_dist_y[3]*Pow(avaut,2) + autos_dist_z[3]*avaut + autos_dist_c[3]
		auto3_sh =  autos_dist_x[4]*Pow(avaut,3) + autos_dist_y[4]*Pow(avaut,2) + autos_dist_z[4]*avaut + autos_dist_c[4]
		
	        se_aut[1] = hhs*Max(auto0_sh,0.0)
	        se_aut[2] = hhs*Max(auto1_sh,0.0)
	        se_aut[3] = hhs*Max(auto2_sh,0.0)
	        se_aut[4] = Max(hhs - (se_aut[1] + se_aut[2] + se_aut[3]),0.0)
	        

		//Fratar to get households by size and autos
		//Initialize seed matrix
		HHLD={{0.0407,0.1742,0.0390,0.0094},
		      {0.0163,0.0819,0.1915,0.0704},
		      {0.0077,0.0355,0.0721,0.0574},
		      {0.0050,0.0212,0.0590,0.0446},
		      {0.0029,0.0121,0.0337,0.0255}}
		
		
		HHLD = {
				{jdist_a0[1], jdist_a1[1], jdist_a2[1], jdist_a3[1]}, 
				{jdist_a0[2], jdist_a1[2], jdist_a2[2], jdist_a3[2]}, 
				{jdist_a0[3], jdist_a1[3], jdist_a2[3], jdist_a3[3]}, 
				{jdist_a0[4], jdist_a1[4], jdist_a2[4], jdist_a3[4]},
				{jdist_a0[5], jdist_a1[5], jdist_a2[5], jdist_a3[5]} 
				}
		
		tmp_aut={0.0725,0.3248,0.3954,0.2073}
		tmp_size={0.2633,0.3600,0.1727,0.1299,0.0741}
			      
	        //Fratar to a maximum of 10 iterations, closure criteria 0.1%
	        for k=1 to 10 do

	        closure=0.0
	        for j=1 to 4 do
	            ratioaut[j]=1
	            if (tmp_aut[j]>0) then do
	              ratioaut[j]=se_aut[j]/tmp_aut[j]
	              arat = abs(1.0 - ratioaut[j])
	              closure=Max(closure,arat)
	            end
	            tmp_aut[j]=0
	        end

	        for i=1 to 5 do
	          for j=1 to 4 do
	              HHLD[i][j] = HHLD[i][j] * ratioaut[j]
	              tmp_size[i]=tmp_size[i]+HHLD[i][j]
	          end // j
	        end   // i
	        
	        
	        for i=1 to 5 do
	            ratiosize[i]=1
	            if (tmp_size[i]>0) then do
	              ratiosize[i]=se_SIZE[i]/tmp_size[i]
	              srat = abs(1.0 - ratiosize[i])
	              closure=Max(closure,srat)
	            end
	            tmp_size[i]=0
	        end

	        for i=1 to 5 do
	          for j=1 to 4 do
	              HHLD[i][j] = HHLD[i][j] * ratiosize[i]
	              tmp_aut[j]=tmp_aut[j]+HHLD[i][j]
	          end // j
	        end   // i  
//
//  check for closure
//
	         if(closure < 0.001) then goto cls
	         
	        end   // k
	        k=k-1
	        cls:
	        
	        for i=1 to 5 do
	         for j=1 to 4 do
	          tmp_size[i]=tmp_size[i] + HHLD[i][j]
	         end // j
	        end // i
	    
	        se.CIterations = k
	        se.HHClosure = closure
	        se.hhp1 = tmp_size[1]
	        se.hhp2 = tmp_size[2]
	        se.hhp3 = tmp_size[3]
	        se.hhp4 = tmp_size[4]
	        se.hhp5 = tmp_size[5]
	        se.hha0 = tmp_aut[1]
	        se.hha1 = tmp_aut[2]
	        se.hha2 = tmp_aut[3]
	        se.hha3 = tmp_aut[4]
	        se.hhp1a0 = HHLD[1][1]
	        se.hhp1a1 = HHLD[1][2]
	        se.hhp1a2 = HHLD[1][3]
	        se.hhp1a3 = HHLD[1][4]
	        se.hhp2a0 = HHLD[2][1]
	        se.hhp2a1 = HHLD[2][2]
	        se.hhp2a2 = HHLD[2][3]
	        se.hhp2a3 = HHLD[2][4]
	        se.hhp3a0 = HHLD[3][1]
	        se.hhp3a1 = HHLD[3][2]
	        se.hhp3a2 = HHLD[3][3]
	        se.hhp3a3 = HHLD[3][4]
	        se.hhp4a0 = HHLD[4][1]
	        se.hhp4a1 = HHLD[4][2]
	        se.hhp4a2 = HHLD[4][3]
	        se.hhp4a3 = HHLD[4][4]
	        se.hhp5a0 = HHLD[5][1]
	        se.hhp5a1 = HHLD[5][2]
	        se.hhp5a2 = HHLD[5][3]
	        se.hhp5a3 = HHLD[5][4]
		end 
	serec=GetNextRecord(SE_Set,null,null)
	UpdateProgressBar("Household Distribution",R2I(100*kk/vhh.length))
	end
    DestroyProgressBar()	
		
	Return(1)
endMacro

Macro "Trip Generation" (Args)
	
	shared  scen_data_dir,ScenArr, ScenSel
	if Args.[Number of Internal Zones] = 0 then do 
		ShowMessage("The Number of Internal Zones Parameter Should be Equal To the Number of Interal Zones in the Socioeconomic Data Table")
		Return(0)
	end	
	
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	
	sefile = Args.[SEDATA Table]
	balance_pa_file = Args.[BALANCE_PA]
	
	se = OpenTable("se", "FFB", {sefile})
	
	SE_Set=se+"|"

	file_prodrates = Args.[Production Rates] 
	prodrates = OpenTable("se", "FFB", {file_prodrates})
	
	vec_persons = GetDataVector(prodrates+"|","persons",)
    vec_r_hbw   = GetDataVector(prodrates+"|","R_hbw",)
    vec_r_hbo   = GetDataVector(prodrates+"|","R_hbo",)
    vec_r_hbsch = GetDataVector(prodrates+"|","R_hbsch",)
	vec_r_nhbw  = GetDataVector(prodrates+"|","R_nhbw",)
	vec_r_nhbo  = GetDataVector(prodrates+"|","R_nhbo",)

	kk = 0
	serec=GetFirstRecord(SE_Set,null)
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do 
			se.hbwp = se.hhp1a0 * vec_r_hbw[1] + se.hhp1a1 * vec_r_hbw[2] + se.hhp1a2 * vec_r_hbw[3] + se.hhp1a3 * vec_r_hbw[4] +
				      se.hhp2a0 * vec_r_hbw[5] + se.hhp2a1 * vec_r_hbw[6] + se.hhp2a2 * vec_r_hbw[7] + se.hhp2a3 * vec_r_hbw[8] + 
					  se.hhp3a0 * vec_r_hbw[9] + se.hhp3a1 * vec_r_hbw[10] + se.hhp3a2 * vec_r_hbw[11] + se.hhp3a3 * vec_r_hbw[12] + 
					  se.hhp4a0 * vec_r_hbw[13] + se.hhp4a1 * vec_r_hbw[14] + se.hhp4a2 * vec_r_hbw[15] + se.hhp4a3 * vec_r_hbw[16] + 
					  se.hhp5a0 * vec_r_hbw[17] + se.hhp5a1 * vec_r_hbw[18] + se.hhp5a2 * vec_r_hbw[19] + se.hhp5a3 * vec_r_hbw[20]  
			
			se.hbop = se.hhp1a0 * vec_r_hbo[1] + se.hhp1a1 * vec_r_hbo[2] + se.hhp1a2 * vec_r_hbo[3] + se.hhp1a3 * vec_r_hbo[4] +
				      se.hhp2a0 * vec_r_hbo[5] + se.hhp2a1 * vec_r_hbo[6] + se.hhp2a2 * vec_r_hbo[7] + se.hhp2a3 * vec_r_hbo[8] + 
					  se.hhp3a0 * vec_r_hbo[9] + se.hhp3a1 * vec_r_hbo[10] + se.hhp3a2 * vec_r_hbo[11] + se.hhp3a3 * vec_r_hbo[12] + 
					  se.hhp4a0 * vec_r_hbo[13] + se.hhp4a1 * vec_r_hbo[14] + se.hhp4a2 * vec_r_hbo[15] + se.hhp4a3 * vec_r_hbo[16] + 
					  se.hhp5a0 * vec_r_hbo[17] + se.hhp5a1 * vec_r_hbo[18] + se.hhp5a2 * vec_r_hbo[19] + se.hhp5a3 * vec_r_hbo[20] 
		
			
			se.hbschp = se.hhp1a0 * vec_r_hbsch[1] + se.hhp1a1 * vec_r_hbsch[2] + se.hhp1a2 * vec_r_hbsch[3] + se.hhp1a3 * vec_r_hbsch[4] +
				      se.hhp2a0 * vec_r_hbsch[5] + se.hhp2a1 * vec_r_hbsch[6] + se.hhp2a2 * vec_r_hbsch[7] + se.hhp2a3 * vec_r_hbsch[8] + 
					  se.hhp3a0 * vec_r_hbsch[9] + se.hhp3a1 * vec_r_hbsch[10] + se.hhp3a2 * vec_r_hbsch[11] + se.hhp3a3 * vec_r_hbsch[12] + 
					  se.hhp4a0 * vec_r_hbsch[13] + se.hhp4a1 * vec_r_hbsch[14] + se.hhp4a2 * vec_r_hbsch[15] + se.hhp4a3 * vec_r_hbsch[16] + 
					  se.hhp5a0 * vec_r_hbsch[17] + se.hhp5a1 * vec_r_hbsch[18] + se.hhp5a2 * vec_r_hbsch[19] + se.hhp5a3 * vec_r_hbsch[20]  		

			se.nhbwp = se.hhp1a0 * vec_r_nhbw[1] + se.hhp1a1 * vec_r_nhbw[2] + se.hhp1a2 * vec_r_nhbw[3] + se.hhp1a3 * vec_r_nhbw[4] +
				      se.hhp2a0 * vec_r_nhbw[5] + se.hhp2a1 * vec_r_nhbw[6] + se.hhp2a2 * vec_r_nhbw[7] + se.hhp2a3 * vec_r_nhbw[8] + 
					  se.hhp3a0 * vec_r_nhbw[9] + se.hhp3a1 * vec_r_nhbw[10] + se.hhp3a2 * vec_r_nhbw[11] + se.hhp3a3 * vec_r_nhbw[12] + 
					  se.hhp4a0 * vec_r_nhbw[13] + se.hhp4a1 * vec_r_nhbw[14] + se.hhp4a2 * vec_r_nhbw[15] + se.hhp4a3 * vec_r_nhbw[16] + 
					  se.hhp5a0 * vec_r_nhbw[17] + se.hhp5a1 * vec_r_nhbw[18] + se.hhp5a2 * vec_r_nhbw[19] + se.hhp5a3 * vec_r_nhbw[20] 

			se.nhbop = se.hhp1a0 * vec_r_nhbo[1] + se.hhp1a1 * vec_r_nhbo[2] + se.hhp1a2 * vec_r_nhbo[3] + se.hhp1a3 * vec_r_nhbo[4] +
				      se.hhp2a0 * vec_r_nhbo[5] + se.hhp2a1 * vec_r_nhbo[6] + se.hhp2a2 * vec_r_nhbo[7] + se.hhp2a3 * vec_r_nhbo[8] + 
					  se.hhp3a0 * vec_r_nhbo[9] + se.hhp3a1 * vec_r_nhbo[10] + se.hhp3a2 * vec_r_nhbo[11] + se.hhp3a3 * vec_r_nhbo[12] + 
					  se.hhp4a0 * vec_r_nhbo[13] + se.hhp4a1 * vec_r_nhbo[14] + se.hhp4a2 * vec_r_nhbo[15] + se.hhp4a3 * vec_r_nhbo[16] + 
					  se.hhp5a0 * vec_r_nhbo[17] + se.hhp5a1 * vec_r_nhbo[18] + se.hhp5a2 * vec_r_nhbo[19] + se.hhp5a3 * vec_r_nhbo[20] 				  
					  
			
		end
		serec=GetNextRecord(SE_Set,null,null)
	end

	attrRates = OpenTable("se", "FFB", {Args.[Attraction Rates]})
	
	vec_attr_totemp      = GetDataVector(attrRates+"|","TOTEMP",)
    vec_attr_industry    = GetDataVector(attrRates+"|","INDUSTRY",)
    vec_attr_retail      = GetDataVector(attrRates+"|","RETAIL",)
    vec_attr_hwyretail   = GetDataVector(attrRates+"|","HWYRETAIL",)
	vec_attr_service     = GetDataVector(attrRates+"|","SERVICE",)
	vec_attr_office      = GetDataVector(attrRates+"|","OFFICE",)
	vec_attr_households  = GetDataVector(attrRates+"|","HOUSEHOLDS",)
	vec_attr_students    = GetDataVector(attrRates+"|","STUDENTS",)
	
	kk = 0
	serec=GetFirstRecord(SE_Set,null)
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do 	

			se.hbwa =  vec_attr_totemp[1] * se.TotEmp 
						
			se.hboa =     vec_attr_industry[2] * se.Industry + vec_attr_retail[2] * se.Retail + 
						vec_attr_hwyretail[2] * se.HwyRet + vec_attr_service[2] * se.Service + vec_attr_office[2] * se.Office + vec_attr_households[2] * se.Households
						
		    se.hbscha = vec_attr_students[3] * se.students
						
			se.nhbwa =     vec_attr_industry[4] * se.Industry + vec_attr_retail[4] * se.Retail + 
						vec_attr_hwyretail[4] * se.HwyRet + vec_attr_service[4] * se.Service + vec_attr_office[4] * se.Office 
						
			se.nhboa =  vec_attr_industry[5] * se.Industry + vec_attr_retail[5] * se.Retail + 
						vec_attr_hwyretail[5] * se.HwyRet + vec_attr_service[5] * se.Service + vec_attr_office[5] * se.Office + vec_attr_households[5] * se.Households

						

		end
		serec=GetNextRecord(SE_Set,null,null)		
	end	

	// Find the production and Attraction sums per purpose
	tot_hbw_p = 0
	tot_hbw_a = 0
	tot_hbo_p = 0
	tot_hbo_a = 0
	tot_hbsch_p = 0
	tot_hbsch_a = 0
	tot_nhbw_p = 0
	tot_nhbw_a = 0
	tot_nhbo_p = 0
	tot_nhbo_a = 0
	
	tot_ix_attr = 0
	tot_ix_prod = 0
	tot_households = 0
	tot_nhbwp = 0
	tot_nhbop = 0
	
	kk = 0
	serec=GetFirstRecord(SE_Set,null)
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do 
			tot_hbw_p = se.hbwp + tot_hbw_p 		
			tot_hbo_p = se.hbop + tot_hbo_p
			tot_hbsch_p = se.hbschp + tot_hbsch_p
			tot_nhbw_p = se.nhbwp + tot_nhbw_p
			tot_nhbo_p = se.nhbop + tot_nhbo_p
			
			tot_hbw_a = se.hbwa + tot_hbw_a 		
			tot_hbo_a = se.hboa + tot_hbo_a
			tot_hbsch_a = se.hbscha + tot_hbsch_a
			tot_nhbw_a = se.nhbwa + tot_nhbw_a
			tot_nhbo_a = se.nhboa + tot_nhbo_a
		end		  
		serec=GetNextRecord(SE_Set,null,null)
	end

	tot_prod = tot_hbw_p + tot_hbo_p + tot_hbsch_p + tot_nhbw_p + tot_nhbo_p
	tot_attr = tot_hbw_a + tot_hbo_a + tot_hbsch_a + tot_nhbw_a + tot_nhbo_a

	Dim nf[5]
	Dim paf[5]
	nf[1] = tot_hbw_p    / tot_hbw_a
	nf[2] = tot_hbo_p    / tot_hbo_a
	
    // Kyle - 4.16.2014 - Changing HBSCH to balance to A's and not P's
    //nf[3] = tot_hbsch_p  / tot_hbsch_a
    nf[3] = tot_hbsch_a  / tot_hbsch_p
	nf[4] = tot_nhbw_p   / tot_nhbw_a
	nf[5] = tot_nhbo_p   / tot_nhbo_a
	
	for i = 1 to nf.length do
		nf[i] = r2s(nf[i])
	end
	paf[1] = tot_hbw_p / tot_prod
	paf[2] = tot_hbo_p / tot_prod
	paf[3] = tot_hbsch_p / tot_prod
	paf[4] = tot_nhbw_p / tot_prod
	paf[5] = tot_nhbo_p / tot_prod

	for i = 1 to paf.length do 
		paf[i] = r2s(paf[i] * 100)
	end 
	
	rpt = OpenFile(report_file, "a")

	WriteLine(rpt, "")
	WriteLine(rpt, "")
	WriteLine(rpt, "    Trip Generation Statistics    ")
	WriteLine(rpt, "    Note: HBSCH purpose is balanced to Attractions and ratio listed is A/P Ratio")
	WriteLine(rpt, "     ------------------------------------------------------------------------------------------------------     ")
	WriteLine(rpt, "    |  Trip Purpose      |  Productions   |  Attractions   |    P/A Ratio    |  % Trips by Trip Purpose    |    ")
	WriteLine(rpt, "    |------------------------------------------------------------------------------------------------------|    ")
	WriteLine(rpt, "    |  HBW               |     "+Lpad(i2s(r2i(tot_hbw_p)),6)+"     |     "+Lpad(i2s(r2i(tot_hbw_a)),6)    + "     |      "+Lpad(nf[1],5)+ "      |            "+Lpad(paf[1],5)+ "            |")
	WriteLine(rpt, "    |  HBO               |     "+Lpad(i2s(r2i(tot_hbo_p)),6)+"     |     "+Lpad(i2s(r2i(tot_hbo_a)),6)+     "     |      "+Lpad(nf[2],5)+ "      |            "+Lpad(paf[2],5)+     "            |")
	WriteLine(rpt, "    |  HBSCH             |     "+Lpad(i2s(r2i(tot_hbsch_p)),6)+"     |     "+Lpad(i2s(r2i(tot_hbsch_a)),6)+   "     |      "+Lpad(nf[3],5)+  "      |            "+Lpad(paf[3],5)+        "            |")
	WriteLine(rpt, "    |  NHBW              |     "+Lpad(i2s(r2i(tot_nhbw_p)),6)+"     |     "+Lpad(i2s(r2i(tot_nhbw_a)),6)+    "     |      "+Lpad(nf[4],5)+  "      |            "+Lpad(paf[4],5)+  "            |")
	WriteLine(rpt, "    |  NHBO              |     "+Lpad(i2s(r2i(tot_nhbo_p)),6)+"     |     "+Lpad(i2s(r2i(tot_nhbo_a)),6)+    "     |      "+Lpad(nf[5],5)+  "      |            "+Lpad(paf[5],5)+ "            |")
	WriteLine(rpt, "     ------------------------------------------------------------------------------------------------------     ")	
	WriteLine(rpt, "")
	CloseFile(rpt)	
		
	RunMacro("close everything")
	Return(1)
    quit:
         Return(ret_value)
		
EndMacro

Macro "Balance Trips" (Args)

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	if Args.[Number of Internal Zones] = 0 then do 
		ShowMessage("The Number of Internal Zones Parameter Should be Equal To the Number of Interal Zones in the Socioeconomic Data Table")
		Return(0)
	end
	
	
	sefile = Args.[SEDATA Table]
	balance_pa_file = Args.[BALANCE_PA]
	
	se = OpenTable("se", "FFB", {sefile})
	
    RunMacro("TCB Init")
// STEP 1: Balance
     Opts = null
     Opts.Input.[Data Set] = {sefile, "se"}
     Opts.Input.[Data View] = {sefile, "se"}
     Opts.Input.[V1 Holding Sets] = {, , , , }
     Opts.Input.[V2 Holding Sets] = {, , , , }
     
     // Kyle - 4.16.2014 - Changing to balance HBSCH to attractions
     // Opts.Field.[Vector 1] = {"se.hbwp", "se.hbop", "se.hbschp", "se.nhbwp", "se.nhbop"}
     // Opts.Field.[Vector 2] = {"se.hbwa", "se.hboa", "se.hbscha", "se.nhbwa", "se.nhboa"}
     Opts.Field.[Vector 1] = {"se.hbwp", "se.hbop", "se.hbscha", "se.nhbwp", "se.nhbop"}
     Opts.Field.[Vector 2] = {"se.hbwa", "se.hboa", "se.hbschp", "se.nhbwa", "se.nhboa"}
     Opts.Global.Pairs = 5
     Opts.Global.[Holding Method] = {1, 1, 1, 1, 1}
     Opts.Global.[Percent Weight] = {, , , , }
     Opts.Global.[Sum Weight] = {, , , , }
     Opts.Global.[V1 Options] = {1, 1, 1, 1, 1}
     Opts.Global.[V2 Options] = {1, 1, 1, 1, 1}
     Opts.Global.[Store Type] = 1
     Opts.Output.[Output Table] = balance_pa_file
     ret_value = RunMacro("TCB Run Procedure", "Balance", Opts, &Ret)
	 if !ret_value then goto quit

	se = OpenTable("se", "FFB", {balance_pa_file})
	SE_Set=se+"|"	 
	serec=GetFirstRecord(SE_Set,null)
	kk = 0
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do	
			se.nhbwp = se.nhbwa
			se.nhbop = se.nhboa 
		end 		  
		serec=GetNextRecord(SE_Set,null,null)
	end	 
	nhbop = GetDataVector(se+"|","nhbop",)
	nhboa = GetDataVector(se+"|","nhboa",)
	nhbwp = GetDataVector(se+"|","nhbwp",)
	nhbwa = GetDataVector(se+"|","nhbwa",)	
	CopyTableFiles(se, null, null, null, Args.[BALANCE_PA2], null)	
	CloseView(se)

	// Open the SE Data table 
	sefile = Args.[SEDATA Table]
	se = OpenTable("se", "FFB", {sefile})
	SE_Set=se+"|"	
	
	tot_ix_prod = 0
	tot_households = 0
	tot_nhbwp = 0
	tot_nhbop = 0
	
	kk = 0
	serec=GetFirstRecord(SE_Set,null)
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do
			tot_households = tot_households + se.Households
			tot_nhbwp = tot_nhbwp + se.nhbwp
			tot_nhbop = tot_nhbop + se.nhbop				
		end	
		if kk > Args.[Number of Internal Zones] then do
			tot_ix_prod = tot_ix_prod + se.ixp
		end
		serec=GetNextRecord(SE_Set,null,null)
	end
	CloseView(se)

	attr_rates = OpenTable("attr_rates_view", "FFB", {Args.[IX Attraction Rates]})
    hh_attr_rate_v =  GetDataVector(attr_rates+"|","Households",)
	CloseView(attr_rates)

	sumIETrips = tot_ix_prod - Args.[IE Trip Factor] * tot_households * hh_attr_rate_v[1]
	
	tot_nhbwnrp = 0
	tot_nhbonrp = 0

	
	for i = 1 to nhbwp.length do 
		if i <= Args.[Number of Internal Zones] then do
			add_nhbwp = Args.[NHBW NR factor] * nhbwp[i] / tot_nhbwp * sumIETrips
			add_nhbop = Args.[NHBO NR factor] * nhbop[i] / tot_nhbop * sumIETrips

			
			tot_nhbwnrp = tot_nhbwnrp + Args.[NHBW NR factor] * nhbwp[i] / tot_nhbwp * sumIETrips
			tot_nhbonrp = tot_nhbonrp + Args.[NHBO NR factor] * nhbop[i] / tot_nhbop * sumIETrips
			nhbwp[i] = nhbwp[i] + add_nhbwp 
			nhbwa[i] = nhbwp[i] 
			
			nhbop[i] = nhbop[i] + add_nhbop
			nhboa[i] = nhbop[i]
		end
	end 
	
	rpt = OpenFile(report_file, "a")

	WriteLine(rpt, "     ----------------------------------------")
	WriteLine(rpt, "    |  Trip Purpose         |  Productions   |")
	WriteLine(rpt, "    |----------------------------------------|    ")
	WriteLine(rpt, "    |  NHBWNR               |     "+Lpad(i2s(r2i(tot_nhbwnrp)),6)+"     |")
	WriteLine(rpt, "    |  NHBONR               |     "+Lpad(i2s(r2i(tot_nhbonrp)),6)+"     |")
	WriteLine(rpt, "     ----------------------------------------")	
	WriteLine(rpt, "")
	CloseFile(rpt)		

 //   CopyTableFiles(se, null, null, null, Args.[BALANCE_PA2], null)	
	balance_pa2 = OpenTable("se", "FFB", {Args.[BALANCE_PA2]})

	setdatavector(balance_pa2+"|", "nhbwp", nhbwp,)
	setdatavector(balance_pa2+"|", "nhbwa", nhbwa,)
	setdatavector(balance_pa2+"|", "nhbop", nhbop,)
	setdatavector(balance_pa2+"|", "nhboa", nhboa,)	


	RunMacro("close everything")
	
	Return(1)
	quit:
		Return(0)
	
endMacro

Macro "Trip Distribution" (Args)

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	
	if Args.[Area Type Code] = 1 then sefile = Args.[GammaCoefficients Small]	
	if Args.[Area Type Code] = 2 then sefile = Args.[GammaCoefficients Large]
	
	if sefile = null then ShowMessage("Please set the [Area Type Code] variable in the model file to 1(=Small) or 2(=Large)")
	
	se = OpenTable("se", "FFB", {sefile})
    coeff_a = VectorToArray(GetDataVector(se+"|","a",))
	coeff_b = VectorToArray(GetDataVector(se+"|","b",))
	coeff_c = VectorToArray(GetDataVector(se+"|","c",))
	
// step 2 Combine Generalized Cost Matrices 

	m1 = OpenMatrix(Args.[HBWGC_PATH], )
	m2 = OpenMatrix(Args.[HBOGC_PATH], )
	m3 = OpenMatrix(Args.[NHBGC_PATH], )
	
	mc1 = CreateMatrixCurrency(m1, "[[AB HBWGC] / [BA HBWGC]]", null, null, )
	mc2 = CreateMatrixCurrency(m2, "[[AB HBOGC] / [BA HBOGC]]", null, null, )
	mc3 = CreateMatrixCurrency(m3, "[[AB NHBGC] / [BA NHBGC]]", null, null, )
	row_labels = GetMatrixRowLabels(mc1)
	values1 = GetMatrixValues(mc1, row_labels, row_labels)
	values2 = GetMatrixValues(mc2, row_labels, row_labels) 
	values3 = GetMatrixValues(mc3, row_labels, row_labels)
	
	CopyMatrixStructure({mc1,mc2}, {{"File Name", Args.[GENCOST]},
     {"Label", "Generalized Cost"},
     {"File Based", "Yes"},
     {"Tables", {"[[AB HBWGC] / [BA HBWGC]]", "[[AB HBOGC] / [BA HBOGC]]","[[AB NHBGC] / [BA NHBGC]]" }},
     {"Operation", "Union"}})

	m4 = OpenMatrix(scen_data_dir + "\\output\\GENCOST.mtx", )
	mc41 = CreateMatrixCurrency(m4, "[[AB HBWGC] / [BA HBWGC]]", null, null, )
	mc42 = CreateMatrixCurrency(m4, "[[AB HBOGC] / [BA HBOGC]]", null, null, )
	mc43 = CreateMatrixCurrency(m4, "[[AB NHBGC] / [BA NHBGC]]", null, null, )
	
	SetMatrixValues(mc41, rows, cols, {"Copy", values1}, )
	SetMatrixValues(mc42, rows, cols, {"Copy", values2}, )
	SetMatrixValues(mc43, rows, cols, {"Copy", values3}, )

    RunMacro("TCB Init")

	// if no K factors are used 
	if Args.[K-factor Toggle] = 0 then do 
	     Opts = null
	     Opts.Input.[PA View Set] = {Args.[BALANCE_PA2], "BALANCE_PA2"}
	     Opts.Input.[FF Matrix Currencies] = {, , , , }
	     Opts.Input.[Imp Matrix Currencies] = {{Args.[GENCOST], "[[AB HBWGC] / [BA HBWGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB HBOGC] / [BA HBOGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB HBOGC] / [BA HBOGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB NHBGC] / [BA NHBGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB NHBGC] / [BA NHBGC]]", "Rows", "Columns"}}
	     Opts.Input.[KF Matrix Currencies] = {, , , , }
	     Opts.Field.[Prod Fields] = {"[BALANCE_PA2].[hbwp]", "[BALANCE_PA2].[hbop]", "[BALANCE_PA2].[hbschp]", "[BALANCE_PA2].[nhbwp]", "[BALANCE_PA2].[nhbop]"}
	     Opts.Field.[Attr Fields] = {"[BALANCE_PA2].[hbwa]", "[BALANCE_PA2].[hboa]", "[BALANCE_PA2].[hbscha]", "[BALANCE_PA2].[nhbwa]", "[BALANCE_PA2].[nhboa]"}
	     Opts.Global.[Purpose Names] = {"HBW", "HBO", "HBSCH", "NHBW", "NHBO"}
	     Opts.Global.Iterations = {10, 10, 10, 10, 10}
	     Opts.Global.Convergence = {0.01, 0.01, 0.01, 0.01, 0.01}
	     Opts.Global.[Constraint Type] = {"Double", "Double", "Double", "Double", "Double"}
	     Opts.Global.[Fric Factor Type] = {"Gamma", "Gamma", "Gamma", "Gamma", "Gamma"}
		 
	     Opts.Global.[A List] = {coeff_a[1], coeff_a[2], coeff_a[3], coeff_a[4], coeff_a[5]}
	     Opts.Global.[B List] = {coeff_b[1], coeff_b[2], coeff_b[3], coeff_b[4], coeff_b[5]}
	     Opts.Global.[C List] = {coeff_c[1], coeff_c[2], coeff_c[3], coeff_c[4], coeff_c[5]}
		 
	     Opts.Flag.[Use K Factors] = {0, 0, 0, 0, 0}
	     Opts.Output.[Output Matrix].Label = "Person Trip Table"
	     Opts.Output.[Output Matrix].Type = "Float"
	     Opts.Output.[Output Matrix].[File based] = "FALSE"
	     Opts.Output.[Output Matrix].Sparse = "False"
	     Opts.Output.[Output Matrix].[Column Major] = "False"
	     Opts.Output.[Output Matrix].Compression = 0
	     Opts.Output.[Output Matrix].[File Name] = Args.[PER_TRIPS]

	     ret_value = RunMacro("TCB Run Procedure", "Gravity", Opts, &Ret)
	     if !ret_value then goto quit
	 end
	// if K factors are used
	if Args.[K-factor Toggle] = 1 then do 
	
	     Opts = null
	     Opts.Input.[PA View Set] = {Args.[BALANCE_PA2], "BALANCE_PA2"}
	     Opts.Input.[FF Matrix Currencies] = {, , , , }
	     Opts.Input.[Imp Matrix Currencies] = {{Args.[GENCOST], "[[AB HBWGC] / [BA HBWGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB HBWGC] / [BA HBWGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB HBWGC] / [BA HBWGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB HBWGC] / [BA HBWGC]]", "Rows", "Columns"}, {Args.[GENCOST], "[[AB HBWGC] / [BA HBWGC]]", "Rows", "Columns"}}
	     Opts.Input.[KF Matrix Currencies] = {{Args.[KFACTORS], "HBW", "Rows", "Columns"}, {Args.[KFACTORS], "HBO", "Rows", "Columns"}, {Args.[KFACTORS], "HBSCH", "Rows", "Columns"}, {Args.[KFACTORS], "NHBW", "Rows", "Columns"}, {Args.[KFACTORS], "NHBO", "Rows", "Columns"}}
	     Opts.Field.[Prod Fields] = {"[BALANCE_PA2].[hbwp]", "[BALANCE_PA2].[hbop]", "[BALANCE_PA2].[hbschp]", "[BALANCE_PA2].[nhbwp]", "[BALANCE_PA2].[nhbop]"}
	     Opts.Field.[Attr Fields] = {"[BALANCE_PA2].[hbwa]", "[BALANCE_PA2].[hboa]", "[BALANCE_PA2].[hbscha]", "[BALANCE_PA2].[nhbwa]", "[BALANCE_PA2].[nhboa]"}
	     Opts.Global.[Purpose Names] = {"HBW", "HBO", "HBSCH", "NHBW", "NHBO"}
	     Opts.Global.Iterations = {10, 10, 10, 10, 10}
	     Opts.Global.Convergence = {0.01, 0.01, 0.01, 0.01, 0.01}
	     Opts.Global.[Constraint Type] = {"Double", "Double", "Double", "Double", "Double"}
	     Opts.Global.[Fric Factor Type] = {"Gamma", "Gamma", "Gamma", "Gamma", "Gamma"}
	     Opts.Global.[A List] = {coeff_a[1], coeff_a[2], coeff_a[3], coeff_a[4], coeff_a[5]}
	     Opts.Global.[B List] = {coeff_b[1], coeff_b[2], coeff_b[3], coeff_b[4], coeff_b[5]}
	     Opts.Global.[C List] = {coeff_c[1], coeff_c[2], coeff_c[3], coeff_c[4], coeff_c[5]}
	     Opts.Flag.[Use K Factors] = {1, 1, 1, 1, 1}
	     Opts.Output.[Output Matrix].Label = "Gravity Matrix"
	     Opts.Output.[Output Matrix].Type = "Float"
	     Opts.Output.[Output Matrix].[File based] = "FALSE"
	     Opts.Output.[Output Matrix].Sparse = "False"
	     Opts.Output.[Output Matrix].[Column Major] = "False"
	     Opts.Output.[Output Matrix].Compression = 0
	     Opts.Output.[Output Matrix].[File Name] = Args.[PER_TRIPS]

	     ret_value = RunMacro("TCB Run Procedure", "Gravity", Opts, &Ret)

	     if !ret_value then goto quit	
		 
	end	

	// Generate the Intrazonal Percentages 	
	mat = OpenMatrix(Args.[PER_TRIPS], )
	core_names = GetMatrixCoreNames(mat)
	SetMatrixCore(mat, core_names[1])
	 
	rpt = OpenFile(report_file, "a")	

	stat_array = MatrixStatistics(mat, )
	
	tot_hbw =   i2s(r2i(stat_array.HBW.sum))
	tot_hbo =   i2s(r2i(stat_array.HBO.sum))
	tot_hbsch = i2s(r2i(stat_array.HBSCH.sum))
	tot_nhbw =  i2s(r2i(stat_array.NHBW.sum))
	tot_nhbo =  i2s(r2i(stat_array.NHBO.sum))

	diag_hbw =   i2s(r2i(stat_array.HBW.sumDiag))
	diag_hbo =   i2s(r2i(stat_array.HBO.sumDiag))
	diag_hbsch = i2s(r2i(stat_array.HBSCH.sumDiag))
	diag_nhbw =  i2s(r2i(stat_array.NHBW.sumDiag))
	diag_nhbo =  i2s(r2i(stat_array.NHBO.sumDiag))
	
	per_hbw = r2s(stat_array.HBW.sumdiag    / stat_array.HBW.sum * 100)
	per_hbo = r2s(stat_array.HBO.sumdiag	 / stat_array.HBO.sum * 100)
	per_hbsch = r2s(stat_array.HBSCH.sumdiag / stat_array.HBSCH.sum * 100)
	per_nhbw = r2s(stat_array.NHBW.sumdiag   / stat_array.NHBW.sum * 100)
	per_nhbo = r2s(stat_array.NHBO.sumdiag   / stat_array.NHBO.sum *100)
	

	WriteLine(rpt, "                                                ")
	WriteLine(rpt, "    Intrazonal Percentages                                                                    ")
	WriteLine(rpt, "     ---------------------------------------------------------------------------------")
	WriteLine(rpt, "    |  Trip Purpose  |   Total Trips   |   Intrazonal Trips   | % Intrazonal Trips    |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  HBW           |     "+Lpad(tot_hbw,6)+"      |         "+Lpad(diag_hbw,6)+"       |        "+Lpad(per_hbw,5)+"          |")
	WriteLine(rpt, "    |  HBO           |     "+Lpad(tot_hbo,6)+"      |         "+Lpad(diag_hbo,6)+"       |        "+Lpad(per_hbo,5)+"          |")
	WriteLine(rpt, "    |  HBSCH         |     "+Lpad(tot_hbsch,6)+"      |         "+Lpad(diag_hbsch,6)+"       |        "+Lpad(per_hbsch,5)+"          |")
	WriteLine(rpt, "    |  NHBW          |     "+Lpad(tot_nhbw,6)+"      |         "+Lpad(diag_nhbw,6)+"       |        "+Lpad(per_nhbw,5)+"          |")
	WriteLine(rpt, "    |  NHBO          |     "+Lpad(tot_nhbo,6)+"      |         "+Lpad(diag_nhbo,6)+"       |        "+Lpad(per_nhbo,5)+"          |")
	WriteLine(rpt, "     ---------------------------------------------------------------------------------")
	WriteLine(rpt, "                                                                                  ")
//	WriteLine(rpt, "__________________________________________________________________________________")
	
	CloseFile(rpt)
	 

	// Compute the TLD 
	 
 //   RunMacro("TCB Init")
// STEP 1: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBW", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBWGC_PATH], "[[AB HBWGC] / [BA HBWGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBW_TLD_GC]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // Step 2
	 Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBW", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBWGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBW_TLD_TT]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 3: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBW", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBWGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBW_TLD_DI]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // step 4
	    RunMacro("TCB Init")
// STEP 4: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBO", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBOGC_PATH], "[[AB HBOGC] / [BA HBOGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBO_TLD_GC]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // Step 5
	 Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBO", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBOGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBO_TLD_TT]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 6: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBO", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBOGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBO_TLD_DI]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // step 7
	 

// STEP 7: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBSCH", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBOGC_PATH], "[[AB HBOGC] / [BA HBOGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBSCH_TLD_GC]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // Step 8
	 Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBSCH", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBOGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBSCH_TLD_TT]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 9: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "HBSCH", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[HBOGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[HBSCH_TLD_DI]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	
	// step 10
	
// STEP 10: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "NHBW", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[NHBW_TLD_GC]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // Step 11
	 Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "NHBW", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[NHBW_TLD_TT]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 12: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "NHBW", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[NHBW_TLD_DI]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	
// STEP 13: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "NHBO", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[NHBO_TLD_GC]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit
	 
	 // Step 14
	 Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "NHBO", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[NHBO_TLD_TT]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 15: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[PER_TRIPS], "NHBO", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[NHBO_TLD_DI]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)
     if !ret_value then goto quit	 
	
	results = { {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0},{0, 0, 0, 0, 0}}
	results[1][1] = r2s(RunMacro("getAverage", Args.[HBW_TLD_GC]))
	results[1][2] = r2s(RunMacro("getAverage", Args.[HBW_TLD_TT]))
	results[1][3] = r2s(RunMacro("getAverage", Args.[HBW_TLD_DI]))

	results[2][1] = r2s(RunMacro("getAverage", Args.[HBO_TLD_GC]))
	results[2][2] = r2s(RunMacro("getAverage", Args.[HBO_TLD_TT]))
	results[2][3] = r2s(RunMacro("getAverage", Args.[HBO_TLD_DI]))	

	results[3][1] = r2s(RunMacro("getAverage", Args.[HBSCH_TLD_GC]))
	results[3][2] = r2s(RunMacro("getAverage", Args.[HBSCH_TLD_TT]))
	results[3][3] = r2s(RunMacro("getAverage", Args.[HBSCH_TLD_DI]))

	results[4][1] = r2s(RunMacro("getAverage", Args.[NHBW_TLD_GC]))
	results[4][2] = r2s(RunMacro("getAverage", Args.[NHBW_TLD_TT]))
	results[4][3] = r2s(RunMacro("getAverage", Args.[NHBW_TLD_DI]))

	results[5][1] = r2s(RunMacro("getAverage", Args.[NHBO_TLD_GC]))
	results[5][2] = r2s(RunMacro("getAverage", Args.[NHBO_TLD_TT]))
	results[5][3] = r2s(RunMacro("getAverage", Args.[NHBO_TLD_DI]))
	
	results[1][4] = per_hbw
	results[2][4] = per_hbo
	results[3][4] = per_hbsch
	results[4][4] = per_nhbw
	results[5][4] = per_nhbo
	
	
	str_results = {" ", " ", " ", " ", " "}
	for i = 1 to 5 do
		for j = 1 to 4 do
			str_results[i] = str_results[i] + "  " + Lpad(results[i][j], 5) + "   |"   
		end
	end
	

	rpt = OpenFile(report_file, "a")		
	WriteLine(rpt, "")
	

	WriteLine(rpt, "                                                          ")
	WriteLine(rpt, "    Trip Distribution Averages                                                                    ")
	WriteLine(rpt, "     --------------------------------------------------------------------------------")
	WriteLine(rpt, "    |  Trip Purpose  |     GC    |    TT    |    DI    | % Intra  | Gamma parameters  |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  HBW           |"+ str_results[1]+ "   a = " + Lpad(r2s(coeff_a[1]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[1]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[1]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  HBO           |"+ str_results[2]+ "   a = " + Lpad(r2s(coeff_a[2]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[2]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[2]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  HBSCH         |"+ str_results[3]+ "   a = " + Lpad(r2s(coeff_a[3]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[3]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[3]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  NHBW          |"+ str_results[4]+ "   a = " + Lpad(r2s(coeff_a[4]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[4]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[4]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  NHBO          |"+ str_results[5]+ "   a = " + Lpad(r2s(coeff_a[5]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[5]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[5]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")

	
	WriteLine(rpt, "")
	CloseFile(rpt)
	
	RunMacro("close everything")
	Return(1)
    quit:
         Return(ret_value)	
	  
	
endMacro


Macro "getAverage" (fileName)

m = OpenMatrix(fileName, "True")
mc = CreateMatrixCurrency(m,,,,)
v = GetMatrixVector(mc, {{"Column", 2}})
result = 0
for i = 1 to v.length do
	result = result + (i - 0.5) * v[i] 
end
result = result / 100 
//ShowArray({v})
//showMessage(r2s(result))
	Return(result)
endMacro

Macro "Mode Split" (Args)

	shared scen_data_dir

	if Args.[Area Type Code] = 1 then sefile = Args.[Mode Shares Small]
	if Args.[Area Type Code] = 2 then sefile = Args.[Mode Shares Large]
	
	if sefile = null then ShowMessage("Please set the [Area Type Code] variable in the model file to 1(=Small) or 2(=Large)")
		
	se = OpenTable("se", "FFB", {sefile})
    auto_shares = GetDataVector(se+"|","Auto",)
	
	 m = OpenMatrix(Args.[PER_TRIPS], )
    
	mc1 = CreateMatrixCurrency(m, "HBW", null, null, )
	mc2 = CreateMatrixCurrency(m, "HBO", null, null, )
	mc3 = CreateMatrixCurrency(m, "HBSCH", null, null, )
	mc4 = CreateMatrixCurrency(m, "NHBW", null, null, )
	mc5 = CreateMatrixCurrency(m, "NHBO", null, null, )
	
/*	
	row_labels = GetMatrixRowLabels(mc1)
	values1 = GetMatrixValues(mc1, row_labels, row_labels)
	values2 = GetMatrixValues(mc2, row_labels, row_labels) 
	values3 = GetMatrixValues(mc3, row_labels, row_labels)
	values4 = GetMatrixValues(mc4, row_labels, row_labels)
	values5 = GetMatrixValues(mc5, row_labels, row_labels)
*/    
	CopyMatrixStructure({mc1,mc2}, {{"File Name", Args.[AUTOPER_TRIPS]},
     {"Label", "Auto Person Trips"},
     {"File Based", "Yes"},
     {"Tables", {"HBW AUTOPER", "HBO AUTOPER","HBSCH AUTOPER", "NHBW AUTOPER", "NHBO AUTOPER" }},
     {"Operation", "Union"}})

    m4 = OpenMatrix(Args.[AUTOPER_TRIPS], )
	mc21 = CreateMatrixCurrency(m4, "HBW AUTOPER", null, null, )
	mc22 = CreateMatrixCurrency(m4, "HBO AUTOPER", null, null, )
	mc23 = CreateMatrixCurrency(m4, "HBSCH AUTOPER", null, null, )
	mc24 = CreateMatrixCurrency(m4, "NHBW AUTOPER", null, null, )
	mc25 = CreateMatrixCurrency(m4, "NHBO AUTOPER", null, null, )

    mc21 := mc1 * auto_shares[1] / 100
    mc22 := mc2 * auto_shares[2] / 100
    mc23 := mc3 * auto_shares[3] / 100
    mc24 := mc4 * auto_shares[4] / 100
    mc25 := mc5 * auto_shares[5] / 100
    

	Return(1)
	quit:
		Return(0)	
	
endMacro

/*
Kyle - updating this macro for Beckley
The number of CVs by employment type is no longer an input.
Instead, it is calculated using rates by employment type.
The rest of the macro then proceeds normally.
*/ 
Macro "CV Trip Generation" (Args) 

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	if Args.[Number of Internal Zones] = 0 then do 
		ShowMessage("The Number of Internal Zones Parameter Should be Equal To the Number of Interal Zones in the Socioeconomic Data Table")
		Return(0)
	end
	sefile  = Args.[SEDATA Table]
	sefile1 = Args.[CV Production Rates]
	sefile2 = Args.[CV Attraction Rates]
    sefile3 = Args.[CV Per Employee]    // Kyle
    
	prod_rates = OpenTable("prod", "FFB", {sefile1})
    prod_ind = VectorToArray(GetDataVector(prod_rates+"|","Industry",))
	prod_ret = VectorToArray(GetDataVector(prod_rates+"|","Retail",))
	prod_hwy = VectorToArray(GetDataVector(prod_rates+"|","HwyRetail",))
	prod_ser = VectorToArray(GetDataVector(prod_rates+"|","Service",))
	prod_off = VectorToArray(GetDataVector(prod_rates+"|","Office",))
    prod_hh  = VectorToArray(GetDataVector(prod_rates+"|","Households",))
    
	attr_rates = OpenTable("attr", "FFB", {sefile2})
    attr_ind = VectorToArray(GetDataVector(attr_rates+"|","Industry EMP",))
	attr_ret = VectorToArray(GetDataVector(attr_rates+"|","Retail EMP",))
	attr_hwy = VectorToArray(GetDataVector(attr_rates+"|","HwyRetail EMP",))
	attr_ser = VectorToArray(GetDataVector(attr_rates+"|","Service EMP",))
	attr_off = VectorToArray(GetDataVector(attr_rates+"|","Office EMP",))
	attr_hh  = VectorToArray(GetDataVector(attr_rates+"|","Households",))
	
    // Kyle - collect rates of vehicles per employee and populate in SE Data
    veh_rates = OpenTable("vehs", "FFB", {sefile3})
    veh_ind = VectorToArray(GetDataVector(veh_rates+"|","Industry",))
	veh_ret = VectorToArray(GetDataVector(veh_rates+"|","Retail",))
	veh_hwy = VectorToArray(GetDataVector(veh_rates+"|","HwyRetail",))
	veh_ser = VectorToArray(GetDataVector(veh_rates+"|","Service",))
	veh_off = VectorToArray(GetDataVector(veh_rates+"|","Office",))
	
    se = OpenTable("se", "FFB", {sefile})
    v_ind = GetDataVector(se+"|","Industry",)
	v_ret = GetDataVector(se+"|","Retail",)
	v_hwy = GetDataVector(se+"|","HwyRet",)
	v_ser = GetDataVector(se+"|","Service",)
	v_off = GetDataVector(se+"|","Office",)
    
    // Kyle -    NumCVs =       Emp     *   CV Rate
    a_temp =   {{"CV1IND", 	    v_ind	, 	veh_ind[1]	},
                {"CV2IND", 	    v_ind	, 	veh_ind[2]	},
                {"CV3IND", 	    v_ind	, 	veh_ind[3]	},
                {"CV1RET", 	    v_ret	, 	veh_ret[1]	},
                {"CV2RET", 	    v_ret	, 	veh_ret[2]	},
                {"CV3RET", 	    v_ret	, 	veh_ret[3]	},
                {"CV1HWY", 	    v_hwy	, 	veh_hwy[1]	},
                {"CV2HWY", 	    v_hwy	, 	veh_hwy[2]	},
                {"CV3HWY", 	    v_hwy	, 	veh_hwy[3]	},
                {"CV1SER", 	    v_ser	, 	veh_ser[1]	},
                {"CV2SER", 	    v_ser	, 	veh_ser[2]	},
                {"CV3SER", 	    v_ser	, 	veh_ser[3]	},
                {"CV1OFF", 	    v_off	, 	veh_off[1]	},
                {"CV2OFF", 	    v_off	, 	veh_off[2]	},
                {"CV3OFF", 	    v_off	, 	veh_off[3]	}}
 
    v_temp = Vector(v_ser.length,"Double",)
    SetView(se)
    for i = 1 to a_temp.length do
        v_temp = a_temp[i][2] * a_temp[i][3]
        test = a_temp[i][1]
        SetDataVector(se + "|",a_temp[i][1],v_temp,)
    end
    
    // ------- End of Kyle's modifications --------
    
    
    
    
    
    
    
    
    
	tot_cv1p = 0
	tot_cv2p = 0
	tot_cv3p = 0
	
	tot_cv1a = 0
	tot_cv2a = 0
	tot_cv3a = 0
	
	SE_Set=se+"|"
	kk=0
	serec=GetFirstRecord(SE_Set,null)
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do
			se.cv1p = se.cv1ind * prod_ind[1] + se.cv1ret * prod_ret[1] + se.cv1hwy * prod_hwy[1]
				+ se.cv1ser * prod_ser[1] + se.cv1off * prod_off[1]
			se.cv2p = se.cv2ind * prod_ind[2] + se.cv2ret * prod_ret[2] + se.cv2hwy * prod_hwy[2]
				+ se.cv2ser * prod_ser[2] + se.cv2off * prod_off[2]
			se.cv3p = se.cv3ind * prod_ind[3] + se.cv3ret * prod_ret[3] + se.cv3hwy * prod_hwy[3]
				+ se.cv3ser * prod_ser[3] + se.cv3off * prod_off[3]
			
			if se.cv1p <> null then tot_cv1p = tot_cv1p + se.cv1p
			if se.cv2p <> null then tot_cv2p = tot_cv2p + se.cv2p 
			if se.cv3p <> null then tot_cv3p = tot_cv3p + se.cv3p 
			
			se.cv1a = se.Industry * attr_ind[1] + se.retail * attr_ret[1] + se.hwyret * attr_hwy[1]
				+ se.service * attr_ser[1] + se.office * attr_off[1] + se.Households * attr_hh[1]
			se.cv2a = se.industry * attr_ind[2] + se.retail * attr_ret[2] + se.hwyret * attr_hwy[2]
				+ se.service * attr_ser[2] + se.office * attr_off[2] + se.Households * attr_hh[2]
			se.cv3a = se.industry * attr_ind[3] + se.retail * attr_ret[3] + se.hwyret * attr_hwy[3]
				+ se.service * attr_ser[3] + se.office * attr_off[3]	+ se.Households * attr_hh[3]
			
			if se.cv1a <> null then tot_cv1a = tot_cv1a + se.cv1a
			if se.cv2a <> null then tot_cv2a = tot_cv2a + se.cv2a 
			if se.cv3a <> null then tot_cv3a = tot_cv3a + se.cv3a 
		end
		serec=GetNextRecord(SE_Set,null,null)
	end
		
	header = "Vehicle Type\tProductions\tAttractions\tNormalization Factor (P/A ratio)\n"
	tot_prod = tot_cv1p + tot_cv2p + tot_cv3p 
	tot_attr = tot_cv1a + tot_cv2a + tot_cv3a
	results = "CV1\t" + r2s(tot_cv1p) + "\t" +     r2s(tot_cv1a) + "\t" +    r2s(tot_cv1p / tot_cv1a) + "\n" +  
	          "CV2\t" + r2s(tot_cv2p) + "\t" +     r2s(tot_cv2a) + "\t" +    r2s(tot_cv2p / tot_cv2a) + "\n" +     
			  "CV3\t" + r2s(tot_cv3p) + "\t" +     r2s(tot_cv3a) + "\t" +    r2s(tot_cv3p / tot_cv3a) + "\n" + 
			  "TOTAL\t"+r2s(tot_prod) + "\t" +     r2s(tot_attr) + "\t" +    r2s(tot_prod / tot_attr) + "\n"
			  

	Dim nf[4]
	Dim paf[4]
	nf[1] = tot_cv1p    / tot_cv1a
	nf[2] = tot_cv2p    / tot_cv2a
	nf[3] = tot_cv3p  / tot_cv3a
	nf[4] = tot_prod  / tot_attr
	
	for i = 1 to nf.length do
		nf[i] = r2s(nf[i])
	end
	paf[1] = tot_cv1p / tot_prod
	paf[2] = tot_cv2p / tot_prod
	paf[3] = tot_cv3p / tot_prod
	paf[4] = 1

	for i = 1 to paf.length do 
		paf[i] = r2s(r2i(paf[i] * 100))
	end 
	

	rpt = OpenFile(report_file, "a")

	WriteLine(rpt, " ")
	WriteLine(rpt, " ")
	WriteLine(rpt, "    Commercial Vehicle Trip Generation Statistics                                                               ")
	WriteLine(rpt, "     ------------------------------------------------------------------------     ")
	WriteLine(rpt, "    |  Trip Purpose      |  Productions   |  Attractions   |    P/A Ratio    |    ")
	WriteLine(rpt, "    |------------------------------------------------------------------------|    ")
	WriteLine(rpt, "    |  CV1               |     "+Lpad(i2s(r2i(tot_cv1p)),6)+"     |     "+Lpad(i2s(r2i(tot_cv1a)),6)    + "     |      "+Lpad(nf[1],5)+ "      |")
	WriteLine(rpt, "    |  CV2               |     "+Lpad(i2s(r2i(tot_cv2p)),6)+"     |     "+Lpad(i2s(r2i(tot_cv2a)),6)+     "     |      "+Lpad(nf[2],5)+  "      |")
	WriteLine(rpt, "    |  CV3               |     "+Lpad(i2s(r2i(tot_cv3p)),6)+"     |     "+Lpad(i2s(r2i(tot_cv3a)),6)+   "     |      "+Lpad(nf[3],5)+  "      |")
	WriteLine(rpt, "    |  TOTAL             |     "+Lpad(i2s(r2i(tot_prod)),6)+"     |     "+Lpad(i2s(r2i(tot_attr)),6)+   "     |      "+Lpad(nf[4],5)+  "      |")
	WriteLine(rpt, "     ------------------------------------------------------------------------     ")	
	WriteLine(rpt, "")
	CloseFile(rpt)		
	
	// Now Balance them 
	 RunMacro("TCB Init")
// STEP 1: Balance
     Opts = null
     Opts.Input.[Data Set] = { sefile, "se"}
     Opts.Input.[Data View] = { sefile, "se"}
     Opts.Input.[V1 Holding Sets] = {, , }
     Opts.Input.[V2 Holding Sets] = {, , }
     Opts.Field.[Vector 1] = {"se.cv1p", "se.cv2p", "se.cv3p"}
     Opts.Field.[Vector 2] = {"se.cv1a", "se.cv2a", "se.cv3a"}
     Opts.Global.Pairs = 3
     Opts.Global.[Holding Method] = {1, 1, 1}
     Opts.Global.[Percent Weight] = {, , }
     Opts.Global.[Sum Weight] = {, , }
     Opts.Global.[V1 Options] = {1, 1, 1}
     Opts.Global.[V2 Options] = {1, 1, 1}
     Opts.Global.[Store Type] = 1
     Opts.Output.[Output Table] = Args.[BALANCE_CV]

     ret_value = RunMacro("TCB Run Procedure", "Balance", Opts, &Ret)

     if !ret_value then goto quit
    
	RunMacro("close everything")
	Return(1)
	quit:
		Return(ret_value)

	
	
endMacro

Macro "CV Trip Distribution" (Args)

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"

	sefile3 = null 
	if Args.[Area Type Code] = 1 then sefile3 = Args.[GammaCoefficients Small]	
	if Args.[Area Type Code] = 2 then sefile3 = Args.[GammaCoefficients Large]
	if sefile3 = null then ShowMessage("Please set the [Area Type Code] variable in the model file to 1(=Small) or 2(=Large)")	

	se = OpenTable("se", "FFB", {sefile3})
    
	coeff_a = VectorToArray(GetDataVector(se+"|","a",))
	coeff_b = VectorToArray(GetDataVector(se+"|","b",))
	coeff_c = VectorToArray(GetDataVector(se+"|","c",))	
	
	// Now Trip Distribution 
	 RunMacro("TCB Init")
     Opts = null
     Opts.Input.[PA View Set] = {Args.[BALANCE_CV], "BALANCE_CV"}
     Opts.Input.[FF Matrix Currencies] = {, , }
     Opts.Input.[Imp Matrix Currencies] = {{Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}, {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}, {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}}
     Opts.Input.[KF Matrix Currencies] = {, , }
     Opts.Field.[Prod Fields] = {"[BALANCE_CV].[cv1p]", "[BALANCE_CV].[cv2p]", "[BALANCE_CV].[cv3p]"}
     Opts.Field.[Attr Fields] = {"[BALANCE_CV].[cv1a]", "[BALANCE_CV].[cv2a]", "[BALANCE_CV].[cv3a]"}
     Opts.Global.[Purpose Names] = {"CV1", "CV2", "CV3"}
     Opts.Global.Iterations = {10, 10, 10}
     Opts.Global.Convergence = {0.01, 0.01, 0.01}
     Opts.Global.[Constraint Type] = {"Double", "Double", "Double"}
     Opts.Global.[Fric Factor Type] = {"Gamma", "Gamma", "Gamma"}
     Opts.Global.[A List] = {coeff_a[6], coeff_a[7], coeff_a[8]}
     Opts.Global.[B List] = {coeff_b[6], coeff_b[7], coeff_b[8]}
     Opts.Global.[C List] = {coeff_c[6], coeff_c[7], coeff_c[8]}
     Opts.Flag.[Use K Factors] = {0, 0, 0}
     Opts.Output.[Output Matrix].Label = "CV Trip Table"
     Opts.Output.[Output Matrix].Type = "Float"
     Opts.Output.[Output Matrix].[File based] = "FALSE"
     Opts.Output.[Output Matrix].Sparse = "False"
     Opts.Output.[Output Matrix].[Column Major] = "False"
     Opts.Output.[Output Matrix].Compression = 0
     Opts.Output.[Output Matrix].[File Name] = Args.[CV_TRIPS]

     ret_value = RunMacro("TCB Run Procedure", "Gravity", Opts, &Ret)

     if !ret_value then goto quit	

	
	// Now trip length 
	// STEP 1: TLD
	
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV1", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV1_TLD_GC]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)
     if !ret_value then goto quit
	 
	 
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV1", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV1_TLD_TT]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)	 
	 if !ret_value then goto quit
	 
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV1", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV1_TLD_DI]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)	 
	 if !ret_value then goto quit

     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV2", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV2_TLD_GC]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)
     if !ret_value then goto quit
	 
	 
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV2", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV2_TLD_TT]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)	 
	 if !ret_value then goto quit
	 
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV2", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV2_TLD_DI]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)	 
	 if !ret_value then goto quit

     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV3", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV3_TLD_GC]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)
     if !ret_value then goto quit
	 
	 
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV3", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV3_TLD_TT]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)	 
	 if !ret_value then goto quit
	 
     Opts = null
     Opts.Input.[Base Currency] = {Args.[CV_TRIPS], "CV3", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[CV3_TLD_DI]
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)	 
	 if !ret_value then goto quit


	mat = OpenMatrix(Args.[CV_TRIPS], )
	core_names = GetMatrixCoreNames(mat)
	SetMatrixCore(mat, core_names[1])
	 	
	stat_array = MatrixStatistics(mat, )
	
	per_cv1 = r2s(stat_array.CV1.sumdiag    /  stat_array.CV1.sum * 100)
	per_cv2 = r2s(stat_array.CV2.sumdiag	 / stat_array.CV2.sum * 100)
	per_cv3 = r2s(stat_array.CV3.sumdiag /     stat_array.CV3.sum * 100)

	results = { {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}
	results[1][1] = r2s(RunMacro("getAverage", Args.[CV1_TLD_GC]))
	results[1][2] = r2s(RunMacro("getAverage", Args.[CV1_TLD_TT]))
	results[1][3] = r2s(RunMacro("getAverage", Args.[CV1_TLD_DI]))

	results[2][1] = r2s(RunMacro("getAverage", Args.[CV2_TLD_GC]))
	results[2][2] = r2s(RunMacro("getAverage", Args.[CV2_TLD_TT]))
	results[2][3] = r2s(RunMacro("getAverage", Args.[CV2_TLD_DI]))	

	results[3][1] = r2s(RunMacro("getAverage", Args.[CV3_TLD_GC]))
	results[3][2] = r2s(RunMacro("getAverage", Args.[CV3_TLD_TT]))
	results[3][3] = r2s(RunMacro("getAverage", Args.[CV3_TLD_DI]))

	
	results[1][4] = per_cv1
	results[2][4] = per_cv2
	results[3][4] = per_cv3

	
	str_results = {" ", " ", " "}
	for i = 1 to 3 do
		for j = 1 to 4 do
			str_results[i] = str_results[i] + "  " + Lpad(results[i][j], 5) + "   |"   
		end
	end
	

	rpt = OpenFile(report_file, "a")		
	WriteLine(rpt, "")
	
	WriteLine(rpt, "                                                                        ")
	WriteLine(rpt, "    Commercial Vehicle Trip Distribution Averages           ")
	WriteLine(rpt, "     -------------------------------------------------------------------------------- ")
	WriteLine(rpt, "    |  Trip Purpose  |     GC    |    TT    |    DI    | % Intra  | Gamma parameters  |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  CV1           |"+ str_results[1]+ "   a = " + Lpad(r2s(coeff_a[6]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[6]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[6]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  CV2           |"+ str_results[2]+ "   a = " + Lpad(r2s(coeff_a[7]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[7]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[7]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  CV3           |"+ str_results[3]+ "   a = " + Lpad(r2s(coeff_a[8]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[8]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[8]), 6) + "      |")
	WriteLine(rpt, "     ---------------------------------------------------------------------------------")
	
	WriteLine(rpt, "")
	CloseFile(rpt)


	 
	RunMacro("close everything")
	Return(1)
    quit:
         Return(ret_value)

endMacro

Macro "External Trip Generation" (Args)

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	if Args.[Number of Internal Zones] = 0 then do 
		ShowMessage("The Number of Internal Zones Parameter Should be Equal To the Number of Interal Zones in the Socioeconomic Data Table")
		Return(0)
	end		
	attr_rates_file = Args.[IX Attraction Rates]
	sefile = Args.[SEDATA Table] 
	
	se = OpenTable("se", "FFB", {sefile})
	
	attr_rates = OpenTable("attr_rates_view", "FFB", {attr_rates_file})
    hh_attr_rate_v =  GetDataVector(attr_rates+"|","Households",)
	ind_attr_rate_v = GetDataVector(attr_rates+"|","Industry",)
	ret_attr_rate_v = GetDataVector(attr_rates+"|","Retail",)
	hwy_attr_rate_v = GetDataVector(attr_rates+"|","HwyRetail",)
	ser_attr_rate_v = GetDataVector(attr_rates+"|","Service",)
	off_attr_rate_v = GetDataVector(attr_rates+"|","Office",)
	
	SE_Set=se+"|"
	serec=GetFirstRecord(SE_Set,null)
	tot_attr = 0
	tot_prod = 0
	kk = 0
	while serec<>null do
		kk=kk+1
		if kk <= Args.[Number of Internal Zones] then do
			se.ixa = se.Households * hh_attr_rate_v[1] + se.Industry * ind_attr_rate_v[1] + 
				     se.Retail * ret_attr_rate_v[1] + se.Service * ser_attr_rate_v[1] + 
					 se.Office * off_attr_rate_v[1] + se.HwyRet * hwy_attr_rate_v[1]
					 
			//if se.ixa <> null then tot_attr = tot_attr + se.ixa
			tot_attr = tot_attr + se.ixa
		end
		if kk > Args.[Number of Internal Zones] then do
			tot_prod = tot_prod + se.ixp
		end
		serec=GetNextRecord(SE_Set,null,null)
	end
	
	
	rpt = OpenFile(report_file, "a")

	WriteLine(rpt, " ")
	WriteLine(rpt, " ")
	WriteLine(rpt, "    External Station Trip Generation Statistics                                                               ")
	WriteLine(rpt, "     ------------------------------------------------------------------------")
	WriteLine(rpt, "    |  Trip Purpose      |  Productions   |  Attractions   |    P/A Ratio    |")
	WriteLine(rpt, "    |------------------------------------------------------------------------|    ")
	WriteLine(rpt, "    |  IX                |     "+Lpad(i2s(r2i(tot_prod)),6)+"     |     "+Lpad(i2s(r2i(tot_attr)),6)    + "     |      "+ Lpad(r2s(tot_prod/tot_attr),5)+ "      |")
	WriteLine(rpt, "     ------------------------------------------------------------------------")	
	WriteLine(rpt, "")
	CloseFile(rpt)	
	
	
	RunMacro("TCB Init")
// STEP 1: Balance
     Opts = null
     Opts.Input.[Data Set] = {Args.[SEDATA Table], "se:1"}
     Opts.Input.[Data View] = {Args.[SEDATA Table], "se:1"}
     Opts.Input.[V1 Holding Sets] = {}
     Opts.Input.[V2 Holding Sets] = {}
     Opts.Field.[Vector 1] = {"[se:1].ixp"}
     Opts.Field.[Vector 2] = {"[se:1].ixa"}
     Opts.Global.Pairs = 1
     Opts.Global.[Holding Method] = {1}
     Opts.Global.[Percent Weight] = {}
     Opts.Global.[Sum Weight] = {}
     Opts.Global.[V1 Options] = {1}
     Opts.Global.[V2 Options] = {1}
     Opts.Global.[Store Type] = 1
     Opts.Output.[Output Table] = Args.[BALANCE_IX]
     ret_value = RunMacro("TCB Run Procedure", "Balance", Opts, &Ret)

     if !ret_value then goto quit
	 	
	RunMacro("close everything")
	Return(1)
    quit:
         Return( ret_value )

endMacro

Macro "External Trip Distribution" (Args)

	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	
	sefile3 = null
	if Args.[Area Type Code] = 1 then sefile3 = Args.[GammaCoefficients Small]	
	if Args.[Area Type Code] = 2 then sefile3 = Args.[GammaCoefficients Large]
	if sefile3 = null then ShowMessage("Please set the [Area Type Code] variable in the model file to 1(=Small) or 2(=Large)")	

	se = OpenTable("se", "FFB", {sefile3})
    
	coeff_a = VectorToArray(GetDataVector(se+"|","a",))
	coeff_b = VectorToArray(GetDataVector(se+"|","b",))
	coeff_c = VectorToArray(GetDataVector(se+"|","c",))	
	
	 // STEP 1: Gravity
     Opts = null
     Opts.Input.[PA View Set] = {Args.[BALANCE_IX], "BALANCE_IX"}
     Opts.Input.[FF Matrix Currencies] = {}
     Opts.Input.[Imp Matrix Currencies] = {{Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}}
     Opts.Input.[KF Matrix Currencies] = {}
     Opts.Field.[Prod Fields] = {"[BALANCE_IX].[ixp]"}
     Opts.Field.[Attr Fields] = {"[BALANCE_IX].[ixa]"}
     Opts.Global.[Purpose Names] = {"IX"}
     Opts.Global.Iterations = {10}
     Opts.Global.Convergence = {0.01}
     Opts.Global.[Constraint Type] = {"Double"}
     Opts.Global.[Fric Factor Type] = {"Gamma"}
     Opts.Global.[A List] = {coeff_a[9]}
     Opts.Global.[B List] = {coeff_b[9]}
     Opts.Global.[C List] = {coeff_c[9]}
     Opts.Flag.[Use K Factors] = {0}
     Opts.Output.[Output Matrix].Label = "IX Trip Table"
     Opts.Output.[Output Matrix].Type = "Float"
     Opts.Output.[Output Matrix].[File based] = "FALSE"
     Opts.Output.[Output Matrix].Sparse = "False"
     Opts.Output.[Output Matrix].[Column Major] = "False"
     Opts.Output.[Output Matrix].Compression = 0
     Opts.Output.[Output Matrix].[File Name] = Args.[IX_TRIPS]

     ret_value = RunMacro("TCB Run Procedure", "Gravity", Opts, &Ret)

     if !ret_value then goto quit
	 
// STEP 1: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[IX_TRIPS], "IX", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB NHBGC] / [BA NHBGC]]", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[IX_TLD_GC]
	 
     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 2: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[IX_TRIPS], "IX", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "[[AB Initial Time] / [BA Initial Time]] (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[IX_TLD_TT]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)

     if !ret_value then goto quit

// STEP 3: TLD
     Opts = null
     Opts.Input.[Base Currency] = {Args.[IX_TRIPS], "IX", "Row ID's", "Col ID's"}
     Opts.Input.[Impedance Currency] = {Args.[NHBGC_PATH], "Length (Skim)", "Origin", "Destination"}
     Opts.Global.[Start Option] = 1
     Opts.Global.[Start Value] = 0
     Opts.Global.[End Option] = 2
     Opts.Global.[End Value] = 100
     Opts.Global.Method = 2
     Opts.Global.[Number of Bins] = 10
     Opts.Global.Size = 1
     Opts.Global.[Statistics Option] = 1
     Opts.Global.[Min Value] = 1
     Opts.Global.[Max Value] = 0
     Opts.Global.[Create Chart] = 0
     Opts.Output.[Output Matrix].Label = "TLD Output Matrix"
     Opts.Output.[Output Matrix].Compression = 1
     Opts.Output.[Output Matrix].[File Name] = Args.[IX_TLD_DI]

     ret_value = RunMacro("TCB Run Procedure", "TLD", Opts, &Ret)
     if !ret_value then goto quit


	mat = OpenMatrix(Args.[IX_TRIPS], )
	core_names = GetMatrixCoreNames(mat)
	SetMatrixCore(mat, core_names[1])
	 	
	stat_array = MatrixStatistics(mat, )
	
	per_ix = r2s(stat_array.IX.sumdiag    /  stat_array.IX.sum * 100)
	
	results = { {0, 0, 0, 0}}
	results[1][1] = r2s(RunMacro("getAverage", Args.[IX_TLD_GC]))
	results[1][2] = r2s(RunMacro("getAverage", Args.[IX_TLD_TT]))
	results[1][3] = r2s(RunMacro("getAverage", Args.[IX_TLD_DI]))
	
	results[1][4] = per_ix

	
	str_results = ""
	for j = 1 to 4 do
		str_results = str_results + "  " + Lpad(results[1][j], 5) + "   |"   
	end

	rpt = OpenFile(report_file, "a")		
	WriteLine(rpt, "")
	
	WriteLine(rpt, "                                                                        ")
	WriteLine(rpt, "    External Trip Trip Distribution Averages           ")
	WriteLine(rpt, "     -------------------------------------------------------------------------------- ")
	WriteLine(rpt, "    |  Trip Purpose  |     GC    |    TT    |    DI    | % Intra  | Gamma parameters  |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  IX            | "+ str_results +"   a = " + Lpad(r2s(coeff_a[9]), 6) + "      |"      )
	WriteLine(rpt, "    |                                                             |   b = " + Lpad(r2s(coeff_b[9]), 6) + "      |")
	WriteLine(rpt, "    |                                                             |   c = " + Lpad(r2s(coeff_c[9]), 6) + "      |")
	WriteLine(rpt, "    |---------------------------------------------------------------------------------|")
	WriteLine(rpt, "")
	CloseFile(rpt)	
	 
	 
	RunMacro("close everything")
    Return(1)
	quit:
		Return(ret_value)

endMacro

Macro "Time of Day" (Args) 

    shared scen_data_dir

	vof_file = null
//	#CHANGED
	vof_file = null
	if Args.[Area Type Code] = 1 then do 
		vof_file = Args.[Vehicle Occupancy Factors S]
		area_type = "Small"
	end
	if Args.[Area Type Code] = 2 then do 
		vof_file = Args.[Vehicle Occupancy Factors L]
		area_type = "Large"
	end
//	#CHANGED
	if vof_file = null then ShowMessage("Please set the [Area Type Code] variable in the model file to 1(=Small) or 2(=Large)")	

	
	vof_table = OpenTable("vof", "FFB", {vof_file})
    vof_am = GetDataVector(vof_table+"|","AM",)
	vof_md = GetDataVector(vof_table+"|","MD",)
	vof_pm = GetDataVector(vof_table+"|","PM",)
	vof_op = GetDataVector(vof_table+"|","OP",)
	
	
	 RunMacro("TCB Init")
// STEP 1: PA2OD
     Opts = null
     Opts.Input.[PA Matrix Currency] = {Args.[AUTOPER_TRIPS], "HBW AUTOPER", "Rows", "Columns"}
	 
	 if area_type = "Small" then do 
		Opts.Input.[Lookup Set] = {Args.[Hourly Small], "HOURLY_Small"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Small.dep_hbw", "HOURLY_Small.dep_hbo", "HOURLY_Small.dep_hbsch", "HOURLY_Small.dep_nhbw", "HOURLY_Small.dep_nhbo"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Small.ret_hbw", "HOURLY_Small.ret_hbo", "HOURLY_Small.ret_hbsch", "HOURLY_Small.ret_nhbw", "HOURLY_Small.ret_nhbo"}	 
	end
	if area_type = "Large" then do
		Opts.Input.[Lookup Set] = {Args.[Hourly Large], "HOURLY_Large"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Large.dep_hbw", "HOURLY_Large.dep_hbo", "HOURLY_Large.dep_hbsch", "HOURLY_Large.dep_nhbw", "HOURLY_Large.dep_nhbo"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Large.ret_hbw", "HOURLY_Large.ret_hbo", "HOURLY_Large.ret_hbsch", "HOURLY_Large.ret_nhbw", "HOURLY_Large.ret_nhbo"}		
	end
     Opts.Field.[Matrix Cores] = {1, 2, 3, 4, 5}
     Opts.Field.[Adjust Fields] = {, , , , }
     Opts.Field.[Peak Hour Field] = {, , , , }
     Opts.Global.[Method Type] = "PA to OD"
     Opts.Global.[Cache Size] = 500000
     Opts.Global.[Adjust Occupancies] = {"No", "No", "No", "No", "No"}
     Opts.Global.[Peak Hour Factor] = {1, 1, 1, 1, 1}
     Opts.Flag.[Separate Matrices] = "No"
     Opts.Flag.[Convert to Vehicles] = {"Yes", "Yes", "Yes", "Yes", "Yes"}
     Opts.Flag.[Include PHF] = {"No", "No", "No", "No", "No"}
     Opts.Flag.[Adjust Peak Hour] = {"No", "No", "No", "No", "No"}
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].Compression = 1
	
	// Auto Trips
	 Opts.Input.[PA Matrix Currency] = {Args.[AUTOPER_TRIPS], "HBW AUTOPER", "Rows", "Columns"}
//   AM 	 
     Opts.Global.[Start Hour] = 6
     Opts.Global.[End Hour] = 8	 
     Opts.Global.[Average Occupancies] = {vof_am[1], vof_am[2], vof_am[3], vof_am[4], vof_am[5]}
     Opts.Output.[Output Matrix].[File Name] = Args.[AMVEH_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit

	// MD
	 Opts.Global.[Start Hour] = 9
     Opts.Global.[End Hour] = 14
     Opts.Global.[Average Occupancies] = {vof_md[1], vof_md[2], vof_md[3], vof_md[4], vof_md[5]}
	 Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[MDVEH_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

	// PM 
     Opts.Global.[Start Hour] = 15
     Opts.Global.[End Hour] = 17	 
     Opts.Global.[Average Occupancies] = {vof_pm[1], vof_pm[2], vof_pm[3], vof_pm[4], vof_pm[5]}
	 Opts.Output.[Output Matrix].Label = "PA to OD"
	 Opts.Output.[Output Matrix].[File Name] = Args.[PMVEH_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 
	 
    // OP1
     Opts.Global.[Start Hour] = 0
     Opts.Global.[End Hour] = 5
     Opts.Global.[Average Occupancies] = {vof_op[1], vof_op[2], vof_op[3], vof_op[4], vof_op[5]}
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OPVEH_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

    // OP2
     Opts.Global.[Start Hour] = 18
     Opts.Global.[End Hour] = 23
     Opts.Global.[Average Occupancies] = {vof_op[1], vof_op[2], vof_op[3], vof_op[4], vof_op[5]}
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OP2VEH_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 
	
	RunMacro("AddMatrices", Args.[OPVEH_TRIPS], Args.[OP2VEH_TRIPS])

	// Commercial Vehicle Trips 
	 Opts.Input.[PA Matrix Currency] = {Args.[CV_TRIPS], "CV1", "Row ID's", "Col ID's"}
	 if area_type = "Small" then do 
		Opts.Input.[Lookup Set] = {Args.[Hourly Small], "HOURLY_Small"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Small.dep_nhbo", "HOURLY_Small.dep_nhbo", "HOURLY_Small.dep_nhbo"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Small.ret_nhbo", "HOURLY_Small.ret_nhbo", "HOURLY_Small.ret_nhbo"}
		
		end
	else do
		Opts.Input.[Lookup Set] = {Args.[Hourly Large], "HOURLY_Large"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Large.dep_nhbo", "HOURLY_Large.dep_nhbo", "HOURLY_Large.dep_nhbo"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Large.ret_nhbo", "HOURLY_Large.ret_nhbo", "HOURLY_Large.ret_nhbo"}
		end	
     Opts.Field.[Matrix Cores] = {1, 2, 3}
     Opts.Field.[Adjust Fields] = {, , }
     Opts.Field.[Peak Hour Field] = {, , }
     Opts.Global.[Method Type] = "PA to OD"

     Opts.Global.[Cache Size] = 500000
     Opts.Global.[Average Occupancies] = {1, 1, 1}
     Opts.Global.[Adjust Occupancies] = {"No", "No", "No"}
     Opts.Global.[Peak Hour Factor] = {1, 1, 1}
     Opts.Flag.[Separate Matrices] = "No"
     Opts.Flag.[Convert to Vehicles] = {"No", "No", "No"}
     Opts.Flag.[Include PHF] = {"No", "No", "No"}
     Opts.Flag.[Adjust Peak Hour] = {"No", "No", "No"}
     Opts.Output.[Output Matrix].Compression = 1
	 
//   AM 
	 Opts.Global.[Start Hour] = 6
     Opts.Global.[End Hour] = 8
	 Opts.Output.[Output Matrix].Label = "PA to OD" 
     Opts.Output.[Output Matrix].[File Name] = Args.[AMCV_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit

	// MD
	 Opts.Global.[Start Hour] = 9
     Opts.Global.[End Hour] = 14
	 Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[MDCV_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

	// PM 
     Opts.Global.[Start Hour] = 15
     Opts.Global.[End Hour] = 17	 
	 Opts.Output.[Output Matrix].Label = "PA to OD"
	 Opts.Output.[Output Matrix].[File Name] = Args.[PMCV_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 
	 
    // OP1
     Opts.Global.[Start Hour] = 0
     Opts.Global.[End Hour] = 5
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OPCV_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

    // OP2
     Opts.Global.[Start Hour] = 18
     Opts.Global.[End Hour] = 23
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OP2CV_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 
	
	RunMacro("AddMatrices", Args.[OPCV_TRIPS] , Args.[OP2CV_TRIPS])
	
	// External External Trips
     //Opts = null
     Opts.Input.[PA Matrix Currency] = {Args.[EE_TRIPS], "EETrips", "From", "To"}
     // Opts.Input.[Lookup Set] = {"C:\\test\\parameters\\HOURLY_Small.bin", "HOURLY_Small"}
	 
	 if area_type = "Small" then do 
		Opts.Input.[Lookup Set] = {Args.[Hourly Small], "HOURLY_Small"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Small.dep_all"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Small.ret_all"}
		
		end
	else do
		Opts.Input.[Lookup Set] = {Args.[Hourly Large], "HOURLY_Large"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Large.dep_all"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Large.ret_all"}
		end		 
	 
     Opts.Field.[Matrix Cores] = {1}
     Opts.Field.[Adjust Fields] = {}
     Opts.Field.[Peak Hour Field] = {}

     Opts.Global.[Method Type] = "PA to OD"

     Opts.Global.[Cache Size] = 500000
     Opts.Global.[Average Occupancies] = {1.0}
     Opts.Global.[Adjust Occupancies] = {"No"}
     Opts.Global.[Peak Hour Factor] = {1}
     Opts.Flag.[Separate Matrices] = "No"
     Opts.Flag.[Convert to Vehicles] = {"No"}
     Opts.Flag.[Include PHF] = {"No"}
     Opts.Flag.[Adjust Peak Hour] = {"No"}
     Opts.Output.[Output Matrix].Compression = 1
	 
	 // AM  
     Opts.Global.[Start Hour] = 6
     Opts.Global.[End Hour] = 8
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[AMEE_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit	

	// MD
	 Opts.Global.[Start Hour] = 9
     Opts.Global.[End Hour] = 14
	 Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[MDEE_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

	// PM 
     Opts.Global.[Start Hour] = 15
     Opts.Global.[End Hour] = 17	 
	 Opts.Output.[Output Matrix].Label = "PA to OD"
	 Opts.Output.[Output Matrix].[File Name] = Args.[PMEE_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 
	 
    // OP1
     Opts.Global.[Start Hour] = 0
     Opts.Global.[End Hour] = 5
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OPEE_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

    // OP2
     Opts.Global.[Start Hour] = 18
     Opts.Global.[End Hour] = 23
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OP2EE_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 	 
	 
	RunMacro("AddMatrices", Args.[OPEE_TRIPS] , Args.[OP2EE_TRIPS]) 
	 
	// IX Trips 

     Opts = null
     Opts.Input.[PA Matrix Currency] = {Args.[IX_TRIPS], "IX", "Row ID's", "Col ID's"}

	 if area_type = "Small" then do 
		Opts.Input.[Lookup Set] = {Args.[Hourly Small], "HOURLY_Small"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Small.dep_all"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Small.ret_all"}
		
		end
	else do
		Opts.Input.[Lookup Set] = {Args.[Hourly Large], "HOURLY_Large"}
		Opts.Field.[Hourly AB Field] = {"HOURLY_Large.dep_all"}
		Opts.Field.[Hourly BA Field] = {"HOURLY_Large.ret_all"}
		end			 

     Opts.Field.[Matrix Cores] = {1}
     Opts.Field.[Adjust Fields] = {}
     Opts.Field.[Peak Hour Field] = {}


     Opts.Global.[Cache Size] = 500000
     Opts.Global.[Average Occupancies] = {1.0}
     Opts.Global.[Adjust Occupancies] = {"No"}
     Opts.Global.[Peak Hour Factor] = {1}
     Opts.Flag.[Separate Matrices] = "No"
     Opts.Flag.[Convert to Vehicles] = {"No"}
     Opts.Flag.[Include PHF] = {"No"}
     Opts.Flag.[Adjust Peak Hour] = {"No"}
     Opts.Output.[Output Matrix].Compression = 1	 
     Opts.Global.[Method Type] = "PA to OD"
 	 
     Opts.Output.[Output Matrix].Label = "PA to OD"	 
     Opts.Global.[Start Hour] = 6
     Opts.Global.[End Hour] = 8	 
     Opts.Output.[Output Matrix].[File Name] = Args.[AMIX_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit	 

	// MD
	 Opts.Global.[Start Hour] = 9
     Opts.Global.[End Hour] = 14
	 Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[MDIX_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

	// PM 
     Opts.Global.[Start Hour] = 15
     Opts.Global.[End Hour] = 17	 
	 Opts.Output.[Output Matrix].Label = "PA to OD"
	 Opts.Output.[Output Matrix].[File Name] = Args.[PMIX_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 
 
    // OP1
     Opts.Global.[Start Hour] = 0
     Opts.Global.[End Hour] = 5
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OPIX_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit 

    // OP2
     Opts.Global.[Start Hour] = 18
     Opts.Global.[End Hour] = 23
     Opts.Output.[Output Matrix].Label = "PA to OD"
     Opts.Output.[Output Matrix].[File Name] = Args.[OP2IX_TRIPS]
     ret_value = RunMacro("TCB Run Procedure", "PA2OD", Opts, &Ret)
     if !ret_value then goto quit

	RunMacro("AddMatrices", Args.[OPIX_TRIPS] , Args.[OP2IX_TRIPS])
	//  Combine all the Time Period Tables for assignemnt
	RunMacro("CreateZeroMatrix", {Args.[AMVEH_TRIPS], "Label",  "HBW AUTOPER (6-9)"},
						{Args.[AMTOT_TRIPS], "AMTOT Trips", "AMTOT Trips"})
	RunMacro("CreateZeroMatrix", {Args.[AMVEH_TRIPS], "Label",  "HBW AUTOPER (6-9)"},
						{Args.[MDTOT_TRIPS], "MDTOT Trips", "MDTOT Trips"})
	RunMacro("CreateZeroMatrix", {Args.[AMVEH_TRIPS], "Label",  "HBW AUTOPER (6-9)"},
						{Args.[PMTOT_TRIPS], "PMTOT Trips", "PMTOT Trips"})
	RunMacro("CreateZeroMatrix", {Args.[AMVEH_TRIPS], "Label",  "HBW AUTOPER (6-9)"},
						{Args.[OPTOT_TRIPS], "OPTOT Trips", "OPTOT Trips"})

  tempMtx = scen_data_dir + "\\interim\\temp.mtx"

  a_tod = {"AM", "MD", "PM", "OP"}
    for t = 1 to a_tod.length do
      tod = a_tod[t]

      m1 = OpenMatrix(Args.(tod + "VEH_TRIPS"),)
    	m2 = OpenMatrix(Args.(tod + "CV_TRIPS"),)
    	m3 = OpenMatrix(Args.(tod + "EE_TRIPS"),)
    	m4 = OpenMatrix(Args.(tod + "IX_TRIPS"),)

      matrix_cores1 = GetMatrixCoreNames(m1)
    	matrix_cores2 = GetMatrixCoreNames(m2)
    	matrix_cores3 = GetMatrixCoreNames(m3)
    	matrix_cores4 = GetMatrixCoreNames(m4)

      mc11 = CreateMatrixCurrency(m1,matrix_cores1[1],,, )
    	mc12 = CreateMatrixCurrency(m1,matrix_cores1[2],,, )
    	mc13 = CreateMatrixCurrency(m1,matrix_cores1[3],,, )
    	mc14 = CreateMatrixCurrency(m1,matrix_cores1[4],,, )
    	mc15 = CreateMatrixCurrency(m1,matrix_cores1[5],,, )

    	mc21 = CreateMatrixCurrency(m2,matrix_cores2[1],,, )
    	mc22 = CreateMatrixCurrency(m2,matrix_cores2[2],,, )
    	mc23 = CreateMatrixCurrency(m2,matrix_cores2[3],,, )

    	mc31 = CreateMatrixCurrency(m3,matrix_cores3[1],,, )

    	mc41 = CreateMatrixCurrency(m4, matrix_cores4[1],,, )

      // Combine everything including EE to get the dimension correct
    	CombineMatrices({mc11, mc12, mc13, mc14, mc15, mc21, mc22, mc23, mc31, mc41}, {{"File Name", tempMtx},
         {"Label", "New Matrix"},
         {"Operation", "Union"}})
    	RunMacro("AddCollapsedMatrix", Args.(tod + "TOT_TRIPS"), tempMtx)

      RunMacro("close everything")
      DeleteFile(tempMtx)
    end

    quit:
         Return(ret_value)
endMacro

Macro "Traffic Assignment" (Args)

    RunMacro("TCB Init")
// STEP 1: Assignment
     Opts = null
     Opts.Input.Database = Args.[BY_HIGHWAY] 
     Opts.Input.Network = Args.[network] 
     Opts.Input.[OD Matrix Currency] = {Args.[AMTOT_TRIPS], "AMTOT Trips", "Rows", "Columns"}
     Opts.Field.[VDF Fld Names] = {"[[AB Initial Time] / [BA Initial Time]]", "[AB_AMCAP / BA_AMCAP]", "Alpha", "None"}
     Opts.Global.[Load Method] = "UE"
     Opts.Global.[Loading Multiplier] = 1
     Opts.Global.[Alpha Value] = 0.15
     Opts.Global.[Beta Value] = 4
     Opts.Global.Convergence = 0.001
     Opts.Global.[Time Minimum] = 0
     Opts.Global.Iterations = r2i(Args.[Assignment Iterations])
     Opts.Global.[Cost Function File] = "emme2.vdf"     // Conical VDF
     Opts.Global.[VDF Defaults] = {, , 6, 0}
     Opts.Output.[Flow Table] = Args.[AM_LINKFLOW]
     ret_value = RunMacro("TCB Run Procedure", "Assignment", Opts, &Ret)
     if !ret_value then goto quit

     Opts = null
     Opts.Input.Database = Args.[BY_HIGHWAY] 
     Opts.Input.Network = Args.[network] 
     Opts.Input.[OD Matrix Currency] = {Args.[MDTOT_TRIPS], "MDTOT Trips", "Rows", "Columns"}
     Opts.Field.[VDF Fld Names] = {"[[AB Initial Time] / [BA Initial Time]]", "[AB_MDCAP / BA_MDCAP]", "Alpha", "None"}
     Opts.Global.[Load Method] = "UE"
     Opts.Global.[Loading Multiplier] = 1
     Opts.Global.[Alpha Value] = 0.15
     Opts.Global.[Beta Value] = 4
     Opts.Global.Convergence = 0.001
     Opts.Global.[Time Minimum] = 0
     Opts.Global.Iterations =  r2i(Args.[Assignment Iterations])
     Opts.Global.[Cost Function File] = "emme2.vdf"
     Opts.Global.[VDF Defaults] = {, , 6, 0}
     Opts.Output.[Flow Table] = Args.[MD_LINKFLOW]
     ret_value = RunMacro("TCB Run Procedure", "Assignment", Opts, &Ret)
     if !ret_value then goto quit	 
	 
     Opts = null
     Opts.Input.Database = Args.[BY_HIGHWAY] 
     Opts.Input.Network = Args.[network] 
     Opts.Input.[OD Matrix Currency] = {Args.[PMTOT_TRIPS], "PMTOT Trips", "Rows", "Columns"}
     Opts.Field.[VDF Fld Names] = {"[[AB Initial Time] / [BA Initial Time]]", "[AB_PMCAP / BA_PMCAP]", "Alpha", "None"}
     Opts.Global.[Load Method] = "UE"
     Opts.Global.[Loading Multiplier] = 1
     Opts.Global.[Alpha Value] = 0.15
     Opts.Global.[Beta Value] = 4
     Opts.Global.Convergence = 0.001
     Opts.Global.[Time Minimum] = 0
     Opts.Global.Iterations =  r2i(Args.[Assignment Iterations])
     Opts.Global.[Cost Function File] = "emme2.vdf"
     Opts.Global.[VDF Defaults] = {, , 6, 0}
     Opts.Output.[Flow Table] = Args.[PM_LINKFLOW]
     ret_value = RunMacro("TCB Run Procedure", "Assignment", Opts, &Ret)
     if !ret_value then goto quit

     Opts = null
     Opts.Input.Database = Args.[BY_HIGHWAY] 
     Opts.Input.Network = Args.[network] 
     Opts.Input.[OD Matrix Currency] = {Args.[OPTOT_TRIPS], "OPTOT Trips", "Rows", "Columns"}
     Opts.Field.[VDF Fld Names] = {"[[AB Initial Time] / [BA Initial Time]]", "[AB_OPCAP / BA_OPCAP]", "Alpha", "None"}
     Opts.Global.[Load Method] = "UE"
     Opts.Global.[Loading Multiplier] = 1
     Opts.Global.[Alpha Value] = 0.15
     Opts.Global.[Beta Value] = 4
     Opts.Global.Convergence = 0.001
     Opts.Global.[Time Minimum] = 0
     Opts.Global.Iterations =  r2i(Args.[Assignment Iterations])
     Opts.Global.[Cost Function File] = "emme2.vdf"
     Opts.Global.[VDF Defaults] = {, , 6, 0}
     Opts.Output.[Flow Table] = Args.[OP_LINKFLOW]
     ret_value = RunMacro("TCB Run Procedure", "Assignment", Opts, &Ret)
     if !ret_value then goto quit	 


	flows = OpenTable("flows", "FFB", {Args.[AM_LINKFLOW]}, {{"Shared", "False"}})
	ab_flow = getdatavector(flows+"|", "AB_FLOW",)
	ba_flow = getdatavector(flows+"|", "BA_FLOW",)
	tot_flow = getdatavector(flows+"|", "TOT_FLOW",)
	strct = GetTableStructure(flows)
	for i = 1 to strct.length do
		strct[i] = strct[i] + {strct[i][1]}
    end
	strct = strct + {{"AB_FLOW_AM", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"BA_FLOW_AM", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"TOT_FLOW_AM", "Real", 12, 2, "True", , , , , , , null}}
	ModifyTable(flows, strct)
	setdatavector(flows+"|", "AB_FLOW_AM", ab_flow,)
	setdatavector(flows+"|", "BA_FLOW_AM", ba_flow,)
	setdatavector(flows+"|", "TOT_FLOW_AM", tot_flow,)
	CloseView(flows)	

	// reaname md
	flows = OpenTable("flows", "FFB", {Args.[MD_LINKFLOW]}, {{"Shared", "False"}})
	ab_flow = getdatavector(flows+"|", "AB_FLOW",)
	ba_flow = getdatavector(flows+"|", "BA_FLOW",)
	tot_flow = getdatavector(flows+"|", "TOT_FLOW",)
	strct = GetTableStructure(flows)
	for i = 1 to strct.length do
		strct[i] = strct[i] + {strct[i][1]}
    end
	strct = strct + {{"AB_FLOW_MD", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"BA_FLOW_MD", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"TOT_FLOW_MD", "Real", 12, 2, "True", , , , , , , null}}
	ModifyTable(flows, strct)
	setdatavector(flows+"|", "AB_FLOW_MD", ab_flow,)
	setdatavector(flows+"|", "BA_FLOW_MD", ba_flow,)
	setdatavector(flows+"|", "TOT_FLOW_MD", tot_flow,)
	CloseView(flows)	

	// rename pm
	flows = OpenTable("flows", "FFB", {Args.[PM_LINKFLOW]}, {{"Shared", "False"}})
	ab_flow = getdatavector(flows+"|", "AB_FLOW",)
	ba_flow = getdatavector(flows+"|", "BA_FLOW",)
	tot_flow = getdatavector(flows+"|", "TOT_FLOW",)
	strct = GetTableStructure(flows)
	for i = 1 to strct.length do
		strct[i] = strct[i] + {strct[i][1]}
    end
	strct = strct + {{"AB_FLOW_PM", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"BA_FLOW_PM", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"TOT_FLOW_PM", "Real", 12, 2, "True", , , , , , , null}}
	ModifyTable(flows, strct)
	setdatavector(flows+"|", "AB_FLOW_PM", ab_flow,)
	setdatavector(flows+"|", "BA_FLOW_PM", ba_flow,)
	setdatavector(flows+"|", "TOT_FLOW_PM", tot_flow,)
	CloseView(flows)

	// rename op
	flows = OpenTable("flows", "FFB", {Args.[OP_LINKFLOW]}, {{"Shared", "False"}})
	ab_flow = getdatavector(flows+"|", "AB_FLOW",)
	ba_flow = getdatavector(flows+"|", "BA_FLOW",)
	tot_flow = getdatavector(flows+"|", "TOT_FLOW",)
	strct = GetTableStructure(flows)
	for i = 1 to strct.length do
		strct[i] = strct[i] + {strct[i][1]}
    end
	strct = strct + {{"AB_FLOW_OP", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"BA_FLOW_OP", "Real", 12, 2, "True", , , , , , , null}}
	strct = strct + {{"TOT_FLOW_OP", "Real", 12, 2, "True", , , , , , , null}}
	ModifyTable(flows, strct)
	setdatavector(flows+"|", "AB_FLOW_OP", ab_flow,)
	setdatavector(flows+"|", "BA_FLOW_OP", ba_flow,)
	setdatavector(flows+"|", "TOT_FLOW_OP", tot_flow,)
	CloseView(flows)	

	RunMacro("CreateTotLinkFlow", Args)
	
	RunMacro("close everything")
	
	Return(1)
    quit:
         Return( ret_value )

endMacro 

Macro "CreateTotLinkFlow" (Args)

	highway_proj = Args.[BY_HIGHWAY] 
	cc = GetDBInfo(highway_proj)
	newMap = CreateMap("newMapName", {{"Scope", cc[1]}, {"Auto Project", "True"}})
	baselayers = GetDBLayers(highway_proj)
	link_layer = AddLayer(newMap, baselayers[2], highway_proj, baselayers[2])
	SetLayer(link_layer)
	
	table1 = Args.[AM_LINKFLOW] 
	vw1 = OpenTable("view_AM", "FFB", {table1},)
	JV1 = JoinViews(, link_layer+".ID", vw1+".ID1",)
	
	table2 = Args.[MD_LINKFLOW] 
	vw2 = OpenTable("view_MD", "FFB", {table2},)
	JV2 = JoinViews(, JV1+".ID", vw2+".ID1",)
	
	table3 = Args.[PM_LINKFLOW] 
	vw3 = OpenTable("view_PM", "FFB", {table3},)
	JV3 = JoinViews(, JV2+".ID", vw3+".ID1",)
	
	table4 = Args.[OP_LINKFLOW] 
	vw4 = OpenTable("view_OP", "FFB", {table4},)
	JV4 = JoinViews(, JV3+".ID", vw4+".ID1",)
	
	vec_id    =  getdatavector(JV4+"|", "ID",)
	vec_ab_count = getdatavector(JV4+"|", "AB Count",)
	vec_ba_count = getdatavector(JV4+"|", "BA Count",)
	
	vec_ab_am =  getdatavector(JV4+"|", "AB_FLOW_AM",)
	vec_ba_am =  getdatavector(JV4+"|", "BA_FLOW_AM",)
	vec_tot_am = getdatavector(JV4+"|", "TOT_FLOW_AM",)

	vec_ab_md =  getdatavector(JV4+"|", "AB_FLOW_MD",)
	vec_ba_md =  getdatavector(JV4+"|", "BA_FLOW_MD",)
	vec_tot_md = getdatavector(JV4+"|", "TOT_FLOW_MD",)

	vec_ab_pm =  getdatavector(JV4+"|", "AB_FLOW_PM",)
	vec_ba_pm =  getdatavector(JV4+"|", "BA_FLOW_PM",)
	vec_tot_pm = getdatavector(JV4+"|", "TOT_FLOW_PM",)

	vec_ab_op =  getdatavector(JV4+"|", "AB_FLOW_OP",)
	vec_ba_op =  getdatavector(JV4+"|", "BA_FLOW_OP",)
	vec_tot_op = getdatavector(JV4+"|", "TOT_FLOW_OP",)

	 //ShowArray(vectorToArray(vec))
	newTable = Args.[TOT_LINKFLOW] 
	total_flows = CreateTable("Total Link Flows", newTable, "FFB", {
    {"ID", "Integer", 4, null, "No"},
//	{"AB Count", "Integer", 4, null, "No"},
//	{"BA Count", "Integer", 4, null, "No"},
	{"AB_FLOW_AM", "Real", 12, 2, "No"},
	{"BA_FLOW_AM", "Real", 12, 2, "No"},
	{"TOT_FLOW_AM", "Real", 12, 2, "No"},
	{"AB_FLOW_MD", "Real", 12, 2, "No"},
	{"BA_FLOW_MD", "Real", 12, 2, "No"},
	{"TOT_FLOW_MD", "Real", 12, 2, "No"},
	{"AB_FLOW_PM", "Real", 12, 2, "No"},
	{"BA_FLOW_PM", "Real", 12, 2, "No"},
	{"TOT_FLOW_PM", "Real", 12, 2, "No"},
	{"AB_FLOW_OP", "Real", 12, 2, "No"},
	{"BA_FLOW_OP", "Real", 12, 2, "No"},
	{"TOT_FLOW_OP", "Real", 12, 2, "No"},
	{"AB_DailyFlow", "Real", 12, 2, "No"},
	{"BA_DailyFlow", "Real", 12, 2, "No"},
	{"DailyFlow", "Real", 12, 2, "No"}
     })
//	closeView(total_flows)

	for i = 1 to vec_id.length do
	rh = AddRecord(total_flows, {
     {"ID", vec_id[i]}
     })
	 end
	 
	vec_ab_daily = getdatavector(total_flows+"|", "AB_DailyFlow",)
	vec_ba_daily = getdatavector(total_flows+"|", "BA_DailyFlow",)
	vec_tot_daily = getdatavector(total_flows+"|", "DailyFlow",)
	
	for i = 1 to vec_id.length do
		ab_flow = 0.0
		ba_flow = 0.0
		tot_flow = 0.0
		
		if vec_ab_am[i] <> null then ab_flow = ab_flow + vec_ab_am[i]
		if vec_ba_am[i] <> null then ba_flow = ba_flow + vec_ba_am[i]
		if vec_tot_am[i] <> null then tot_flow = tot_flow + vec_tot_am[i]
		
		if vec_ab_md[i] <> null then ab_flow = ab_flow + vec_ab_md[i]
		if vec_ba_md[i] <> null then ba_flow = ba_flow + vec_ba_md[i]
		if vec_tot_md[i] <> null then tot_flow = tot_flow + vec_tot_md[i]

		if vec_ab_pm[i] <> null then ab_flow = ab_flow + vec_ab_pm[i]
		if vec_ba_pm[i] <> null then ba_flow = ba_flow + vec_ba_pm[i]
		if vec_tot_pm[i] <> null then tot_flow = tot_flow + vec_tot_pm[i]

		if vec_ab_op[i] <> null then ab_flow = ab_flow + vec_ab_op[i]
		if vec_ba_op[i] <> null then ba_flow = ba_flow + vec_ba_op[i]
		if vec_tot_op[i] <> null then tot_flow = tot_flow + vec_tot_op[i]		

		if ab_flow <> 0 then vec_ab_daily[i] = ab_flow
		if ba_flow <> 0 then vec_ba_daily[i] = ba_flow
		if tot_flow <> 0 then vec_tot_daily[i] = tot_flow
	end
//	ShowArray(vectorToArray(vec_ab_daily))

//	setdatavector(total_flows+"|", "AB Count", vec_ab_count,)
//	setdatavector(total_flows+"|", "BA Count", vec_ba_count,)
	
	setdatavector(total_flows+"|", "AB_FLOW_AM", vec_ab_am,)
	setdatavector(total_flows+"|", "BA_FLOW_AM", vec_ba_am,)
	setdatavector(total_flows+"|", "TOT_FLOW_AM", vec_tot_am,)

	setdatavector(total_flows+"|", "AB_FLOW_MD", vec_ab_md,)
	setdatavector(total_flows+"|", "BA_FLOW_MD", vec_ba_md,)
	setdatavector(total_flows+"|", "TOT_FLOW_MD", vec_tot_md,)	
	
	setdatavector(total_flows+"|", "AB_FLOW_PM", vec_ab_pm,)
	setdatavector(total_flows+"|", "BA_FLOW_PM", vec_ba_pm,)
	setdatavector(total_flows+"|", "TOT_FLOW_PM", vec_tot_pm,)

	setdatavector(total_flows+"|", "AB_FLOW_OP", vec_ab_op,)
	setdatavector(total_flows+"|", "BA_FLOW_OP", vec_ba_op,)
	setdatavector(total_flows+"|", "TOT_FLOW_OP", vec_tot_op,)	
	
	setdatavector(total_flows+"|", "AB_DailyFlow", vec_ab_daily,)
	setdatavector(total_flows+"|", "BA_DailyFlow", vec_ba_daily,)
	setdatavector(total_flows+"|", "DailyFlow", vec_tot_daily,)	
	
	closeView(total_flows)

endMacro


Macro "Generate Validation Reports" (Args)
	shared  scen_data_dir,ScenArr, ScenSel
	report_file = scen_data_dir + ScenArr[ScenSel[1]][1]	+ "_report.txt"
	
	highway_proj = Args.[BY_HIGHWAY] 
	table1 = Args.[TOT_LINKFLOW] 
	
	cc = GetDBInfo(highway_proj)
	newMap = CreateMap("newMapName", {{"Scope", cc[1]}, {"Auto Project", "True"}})
	baselayers = GetDBLayers(highway_proj)
	link_layer = AddLayer(newMap, baselayers[2], highway_proj, baselayers[2])
	SetLayer(link_layer)
	
	vw1 = OpenTable("view_AM", "FFB", {table1},)
	JV1 = JoinViews(, link_layer+".ID", vw1+".ID",)
	
	vec_ab_count = getdatavector(JV1+"|", "AB Count",)
	vec_ba_count = getdatavector(JV1+"|", "BA Count",)
	vec_daily_count = getdatavector(JV1+"|", "DailyCount",)
	vec_daily_flow = getdatavector(JV1+"|", "DailyFlow",)
	vec_factype_cd = getdatavector(JV1+"|", "FACTYPE_CD",)
	vec_length     = getdatavector(JV1+"|", "Length",)
	vec_ab_daily   = getdatavector(JV1+"|", "AB_DailyFlow",)
	vec_ba_daily   = getdatavector(JV1+"|", "BA_DailyFlow",)
	//vec_funcl_cd  =  getdatavector(JV1+"|",  "FUNCL_CD",)
	ab_count = vectorToArray(vec_ab_count) 
	ba_count = vectorToArray(vec_ba_count)
	daily_flow = vectorToArray(vec_daily_flow)
	factype_cd = vectorToArray(vec_factype_cd)
	
	report_facility_type = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
	vmt_by_facility =      {0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0}
	count_by_facility =    {0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0}

//  VMT	
	for i = 1 to ab_count.length do 
		if ab_count[i] = null then ab_count[i] = -1
		if ba_count[i] = null then ba_count[i] = -1 
		if vec_daily_count[i] = null then vec_daily_count[i] = -1
        if vec_daily_flow[i] = null then vec_daily_flow[i] = -1
	end
	
	numObsByFactType = {0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0}
	volumeByFactType = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
	
	for i = 1 to ab_count.length do 
		if ab_count[i] <> -1 then do
			for k = 1 to report_facility_type.length do
				if factype_cd[i] = report_facility_type[k] then do 
					if vec_ab_daily[i] <> null then do
						vmt_by_facility[k] = vmt_by_facility[k] + vec_ab_daily[i] * vec_length[i]
						volumeByFactType[k] = volumeByFactType[k] + vec_ab_daily[i]
					end
					count_by_facility[k] = count_by_facility[k] + ab_count[i] * vec_length[i]
					numObsByFactType[k]   = numObsByFactType[k] + 1
				end
			end
		end
		if ba_count[i] <> -1 then do
			for k = 1 to report_facility_type.length do
				if factype_cd[i] = report_facility_type[k] then do 
					if vec_ba_daily[i] <> null then do
						vmt_by_facility[k] = vmt_by_facility[k] + vec_ba_daily[i] * vec_length[i] 
						volumeByFactType[k] = volumeByFactType[k] + vec_ba_daily[i]
					end
					count_by_facility[k] = count_by_facility[k] + ba_count[i] * vec_length[i]
					numObsByFactType[k]   = numObsByFactType[k] + 1
				end
			end
		end		
	end

	
	dim deviation[vmt_by_facility.length]
	
	// VMT summary 
	vmt_summary_string = ""
	for i = 1 to report_facility_type.length do 
		if count_by_facility[i]<> 0 then deviation[i] = i2S(r2i((vmt_by_facility[i] -count_by_facility[i]) / count_by_facility[i] * 100))
		if count_by_facility[i] = 0 then deviation[i] = "NA"
		vmt_by_facility[i]   =  i2s(r2i(vmt_by_facility[i]))
		// count_by_facility[i] =  i2s(r2i(count_by_facility[i]))
		
		// = vmt_summary_string + i2s(r2i(vmt_by_facility[i])) + "\t" + 
		// i2s(r2i(count_by_facility[i])) + "\t" + i2s(r2i(deviation)) + "\n"
	end

	rpt = OpenFile(report_file, "a")	

	WriteLine(rpt, "                                        ")
	WriteLine(rpt, "    VMT Summaries (Count Links Only)                                                                    ")
	WriteLine(rpt, "     ------------------------------------------------------------------------")
	WriteLine(rpt, "    |  Facility Type       |     TOT VMT    |   Count VMT    | % Deviation   |")
	WriteLine(rpt, "    |------------------------------------------------------------------------|")
	WriteLine(rpt, "    |  Freeway             |     "+Lpad(vmt_by_facility[1],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[1])),6)+"     |     "+Lpad(deviation[1],5)+"     |")
	WriteLine(rpt, "    |  Multilane Highway   |     "+Lpad(vmt_by_facility[2],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[2])),6)+"     |     "+Lpad(deviation[2],5)+"     |")
	WriteLine(rpt, "    |  Two-lane Highway    |     "+Lpad(vmt_by_facility[3],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[3])),6)+"     |     "+Lpad(deviation[3],5)+"     |")
	WriteLine(rpt, "    |  Urban Arterial I    |     "+Lpad(vmt_by_facility[4],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[4])),6)+"     |     "+Lpad(deviation[4],5)+"     |")
	WriteLine(rpt, "    |  Urban Arterial II   |     "+Lpad(vmt_by_facility[5],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[5])),6)+"     |     "+Lpad(deviation[5],5)+"     |")
	WriteLine(rpt, "    |  Urban Arterial III  |     "+Lpad(vmt_by_facility[6],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[6])),6)+"     |     "+Lpad(deviation[6],5)+"     |")
	WriteLine(rpt, "    |  Urban Arterial IV   |     "+Lpad(vmt_by_facility[7],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[7])),6)+"     |     "+Lpad(deviation[7],5)+"     |")
	WriteLine(rpt, "    |  Collector           |     "+Lpad(vmt_by_facility[8],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[8])),6)+"     |     "+Lpad(deviation[8],5)+"     |")
    WriteLine(rpt, "    |  Local               |     "+Lpad(vmt_by_facility[9],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[9])),6)+"     |     "+Lpad(deviation[9],5)+"     |")
    // WriteLine(rpt, "    |  Diamond Ramp        |     "+Lpad(vmt_by_facility[10],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[10])),6)+"     |     "+Lpad(deviation[10],5)+"     |")
    // WriteLine(rpt, "    |  Loop Ramp           |     "+Lpad(vmt_by_facility[11],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[11])),6)+"     |     "+Lpad(deviation[11],5)+"     |")
    // WriteLine(rpt, "    |  External Station    |     "+Lpad(vmt_by_facility[12],6)+"     |     "+Lpad(i2s(r2i(count_by_facility[12])),6)+"     |     "+Lpad(deviation[12],5)+"     |")
	WriteLine(rpt, "     ------------------------------------------------------------------------")
	WriteLine(rpt, "                                                                         ")
	// WriteLine(rpt, "_____________________________________________________________________________")
	
	
	// ShowMessage(vmt_summary_string)
	
	
	// Screenlines now 
	
	// Get all the screenline names 
	vec_screenlines = getdatavector(JV1+"|", "Screenline",)
	v = GetDataVector(JV1+"|", "Screenline", {{"Sort Order", {{"Screenline", "Descending"}}}} )

	
	num_screenlines = 0
	index = 1
	while index < v.length do
		if v[index] <> v[index + 1] then do
			num_screenlines = num_screenlines + 1
		end
		index = index + 1
	end

	
	dim screenline_names[num_screenlines]
	
	for i = 1 to num_screenlines do 
		screenline_names[i] = -999
	end
	
	for i = 1 to vec_screenlines.length do 
		if vec_screenlines[i] <> null then do
			isAlreadyThere = "no"
			for j = 1 to num_screenlines do
				if vec_screenlines[i] = screenline_names[j] then isAlreadyThere = "yes"
			end
			if isAlreadyThere = "no" then do
				modify = "yes"
				for k = 1 to num_screenlines do
					if screenline_names[k] = -999 and modify = "yes" then do
						screenline_names[k] = vec_screenlines[i]
						modify = "no"
					end
				end
			end
		end 
	end	
	

	
	dim screenline_flow[num_screenlines]
	dim screenline_count[num_screenlines]
	
	for i = 1  to num_screenlines do 
		screenline_flow[i] = 0
		screenline_count[i] = 0 
	end
	
	for i = 1 to ab_count.length do 
		if ab_count[i] <> -1 then do
			for k = 1 to screenline_names.length do
				if vec_screenlines[i] = screenline_names[k] then do 
					if vec_ab_daily[i] <> null then screenline_flow[k] = screenline_flow[k] + vec_ab_daily[i]
					screenline_count[k] = screenline_count[k] + ab_count[i]
				end
			end
		end
		if ba_count[i] <> -1 then do
			for k = 1 to screenline_names.length do
				if vec_screenlines[i] = screenline_names[k] then do 
					if vec_ba_daily[i] <> null then screenline_flow[k] = screenline_flow[k] + vec_ba_daily[i]
					screenline_count[k] = screenline_count[k] + ba_count[i]
				end
			end
		end		
	end	
	
	
	WriteLine(rpt, "                                                            ")
	WriteLine(rpt, "                                    ")
	WriteLine(rpt, "    Screenline Comparisons                                                          ")
	WriteLine(rpt, "    -----------------------------------------------------------     ")
	WriteLine(rpt, "    |                     |  Count   |  Modeled |             |    ")
	WriteLine(rpt, "    |  Screenline         |  Volume  |  Volume  | % Deviation |    ")
	WriteLine(rpt, "    |---------------------------------------------------------|    ")	
 
    
	for i = 1 to screenline_names.length do 
			name = i2s(screenline_names[i])
			if screenline_count[i]<> 0 then ratio = i2s(r2i((screenline_flow[i] -screenline_count[i])/ screenline_count[i] * 100))			
			screenline_count[i] = i2s(screenline_count[i])
			screenline_flow[i]  = i2s(r2i(screenline_flow[i]))
			WriteLine(rpt, "    |  Screenline "+Lpad(name,5)+"   | "+Lpad(screenline_count[i],8)+" | "+Lpad(screenline_flow[i],8)+" |  "+Lpad(ratio,5)+"      |      ")
	end
	WriteLine(rpt, "     -------------------------------------------------------     ")
	WriteLine(rpt, " ")
	
	//volume_thresholds = {0, 1001, 2501, 5001, 10001, 25001, 50001, 10000000}
    volume_thresholds = {0, 1000, 2500, 5000, 10000, 25000, 50000, 10000000}
	dim daily_count_byVolType[volume_thresholds.length - 1]
	dim daily_volume_byVolType[volume_thresholds.length - 1]
	dim numObs_byVolType[volume_thresholds.length]
	
    
    // Kyle - redoing this calculation using vector math
    qry = "Select * where DailyCount > 0"
    numCounts = SelectByQuery("count links","Several",qry)
    v_countFlow = getdatavector(JV1+"|count links", "DailyFlow",{{"Missing as Zero","True"}})
    v_countCount = getdatavector(JV1+"|count links", "DailyCount",)
    
    for i = 2 to volume_thresholds.length do
        lowBound = volume_thresholds[i-1]
        highBound = volume_thresholds[i]
        
        v_tempFlow = if ( v_countCount > lowBound and v_countCount <= highBound ) then v_countFlow else 0
        v_tempCount = if ( v_countCount > lowBound and v_countCount <= highBound ) then v_countCount else 0
        
        daily_volume_byVolType[i-1] = VectorStatistic(v_tempFlow,"sum",)
        daily_count_byVolType[i-1] = VectorStatistic(v_tempCount,"sum",)
    end

    
    
    

    
    
	results3 = {"0", "0", "0", "0", "0", "0", "0"}
	for i = 1 to 7 do 
		if daily_count_byVolType[i] <> 0 then results3[i] = i2s(r2i((daily_volume_byVolType[i] - daily_count_byVolType[i]) / daily_count_byVolType[i] * 100))
	end
        
    // Kyle - create a total line
    //SetLayer(JV1)

    totalFlow = VectorStatistic(v_countFlow,"sum",)
    totalCount = VectorStatistic(vec_daily_count,"sum",)
    pctDiff = ( totalFlow - totalCount ) / totalCount * 100
        
    
	results0 = {"        < 1,000", " 1,001 -  2,500", " 2,501 -  5,000", " 5,001 - 10,000", "10,001 - 25,000", "25,001 - 50,000", "       > 50,001"}
	results4 = {"60", "47", " 36", " 29", " 25", " 22", " 21"}

	WriteLine(rpt, "                                                            ")
	WriteLine(rpt, "     Percent Assignment Summary by Volume Group                ")
	WriteLine(rpt, "     -----------------------------------------------------------------------------------------------     ")
	WriteLine(rpt, "     |    Volume Group      |   Daily Count   | Daily Flow      | Model Diff %    | Target Diff %   |   ")
	WriteLine(rpt, "     -----------------------------------------------------------------------------------------------     ")
	for i = 1 to results0.length do 
		WriteLine(rpt, "     |   " + results0[i] + "    |     " + Lpad(i2s(r2i(daily_count_byVolType[i])), 8) + "    |     " + Lpad(i2s(r2i(daily_volume_byVolType[i])), 8) + "    |     " + Lpad(results3[i], 8) + "    |     " + Lpad(results4[i], 8) + "    |")
	end
    WriteLine(rpt, "     |           total      |     " + Lpad(String(Round(totalCount,0)),8) + "    |     " + Lpad(String(Round(totalFlow,0)),8) + "    |     " + Lpad(String(Round(pctDiff,0)),8) + "    |                 |")
	WriteLine(rpt, "     -----------------------------------------------------------------------------------------------     ")
    
    
	// Calculate %RMSE for each volume group


	//rmse_fact_type = {{10, 20}, {11}, {12,13, 21, 22}, {14, 23, 24}, {10, 11, 12, 13, 14, 20, 21, 22, 23, 24}}
	//                                                                 // "Total"
    // This one includes ramps/ext stations/locals
    //rmse_fact_type = {{1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {1,2,3,4,5,6,7,8,9,10,11,12}}
    rmse_fact_type = {{1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {1,2,3,4,5,6,7,8}}
    rmse_vol_fact_type = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	rmse_numObs_fact_type = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	rmse_count_fact_type = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	rmse_by_fact_type = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	rmse_diff_fact_type = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	
/*
	for i = 1 to vec_funcl_cd.length do 
		if vec_daily_count[i] <> -1 then do
			for j = 1 to rmse_fact_type.length  do
				for k = 1 to rmse_fact_type[j].length do 
					if rmse_fact_type[j][k] = vec_funcl_cd[i] then do
						rmse_vol_fact_type[j] = rmse_vol_fact_type[j] + vec_daily_flow[i]
						rmse_count_fact_type[j] = rmse_count_fact_type[j] + vec_daily_count[i]
						rmse_diff_fact_type[j] = rmse_diff_fact_type[j]  + (vec_daily_flow[i] - vec_daily_count[i]) * (vec_daily_flow[i] - vec_daily_count[i])
						rmse_numObs_fact_type[j] = rmse_numObs_fact_type[j] + 1
					end
				end
			end
		end
	end
*/
	for i = 1 to vec_factype_cd.length do 
        if vec_daily_count[i] <> -1 then do
            for j = 1 to rmse_fact_type.length  do
                for k = 1 to rmse_fact_type[j].length do 
                    if rmse_fact_type[j][k] = vec_factype_cd[i] then do
                        rmse_vol_fact_type[j] = rmse_vol_fact_type[j] + vec_daily_flow[i]
                        rmse_count_fact_type[j] = rmse_count_fact_type[j] + vec_daily_count[i]
                        rmse_diff_fact_type[j] = rmse_diff_fact_type[j]  + (vec_daily_flow[i] - vec_daily_count[i]) * (vec_daily_flow[i] - vec_daily_count[i])
                        rmse_numObs_fact_type[j] = rmse_numObs_fact_type[j] + 1
                    end
                end
            end
        end
	end
	
	for i = 1 to rmse_by_fact_type.length do
		rmse_by_fact_type[i] = "NA"
    end
	
	for i = 1 to rmse_by_fact_type.length do
		if rmse_numObs_fact_type[i] <> 0 then do
			rmse_by_fact_type[i] = sqrt( rmse_diff_fact_type[i] / rmse_numObs_fact_type[i]) / (rmse_count_fact_type[i] / rmse_numObs_fact_type[i]) * 100		
			rmse_by_fact_type[i] = i2s(r2i(Round(rmse_by_fact_type[i],0)))
            
		end
	end
		
	WriteLine(rpt, "")
	WriteLine(rpt, "    Percent Root Mean Square Error by Facility Type          ")
	WriteLine(rpt, "    |-----------------------------------------------------------------    ")
	WriteLine(rpt, "    |  Facility Type       | Observations |    Model    |    Target   |    ")
	WriteLine(rpt, "    |-----------------------------------------------------------------|    ")
	WriteLine(rpt, "    |  Freeway             |   "+Lpad(i2s(rmse_numObs_fact_type[1]), 5) + "      |    "+Lpad(rmse_by_fact_type[1], 5) +  "    |      25     |")
	WriteLine(rpt, "    |  Multilane Highway   |   "+Lpad(i2s(rmse_numObs_fact_type[2]), 5) + "      |    "+Lpad(rmse_by_fact_type[2], 5) +  "    |      40     |")
	WriteLine(rpt, "    |  Two-lane Highway    |   "+Lpad(i2s(rmse_numObs_fact_type[3]), 5) + "      |    "+Lpad(rmse_by_fact_type[3], 5) +  "    |      50     |")
	WriteLine(rpt, "    |  Urban Arterial I    |   "+Lpad(i2s(rmse_numObs_fact_type[4]), 5) + "      |    "+Lpad(rmse_by_fact_type[4], 5) +  "    |      50     |")
	WriteLine(rpt, "    |  Urban Arterial II   |   "+Lpad(i2s(rmse_numObs_fact_type[5]), 5) + "      |    "+Lpad(rmse_by_fact_type[5], 5) +  "    |      50     |")
	WriteLine(rpt, "    |  Urban Arterial III  |   "+Lpad(i2s(rmse_numObs_fact_type[6]), 5) + "      |    "+Lpad(rmse_by_fact_type[6], 5) +  "    |      50     |")
	WriteLine(rpt, "    |  Urban Arterial IV   |   "+Lpad(i2s(rmse_numObs_fact_type[7]), 5) + "      |    "+Lpad(rmse_by_fact_type[7], 5) +  "    |      50     |")
	WriteLine(rpt, "    |  Collector           |   "+Lpad(i2s(rmse_numObs_fact_type[8]), 5) + "      |    "+Lpad(rmse_by_fact_type[8], 5) +  "    |      65     |")
	// WriteLine(rpt, "    |  Local               |   "+Lpad(i2s(rmse_numObs_fact_type[9]), 5) + "      |    "+Lpad(rmse_by_fact_type[9], 5) +  "    |       ?     |")	
    // WriteLine(rpt, "    |  Diamond Ramp        |   "+Lpad(i2s(rmse_numObs_fact_type[10]), 5) + "      |    "+Lpad(rmse_by_fact_type[10], 5) +  "    |       ?     |")	
    // WriteLine(rpt, "    |  Loop Ramp           |   "+Lpad(i2s(rmse_numObs_fact_type[11]), 5) + "      |    "+Lpad(rmse_by_fact_type[11], 5) +  "    |       ?     |")	
    // WriteLine(rpt, "    |  External Station    |   "+Lpad(i2s(rmse_numObs_fact_type[12]), 5) + "      |    "+Lpad(rmse_by_fact_type[12], 5) +  "    |       0     |")	
    WriteLine(rpt, "    |  Total               |   "+Lpad(i2s(rmse_numObs_fact_type[9]), 5) + "      |    "+Lpad(rmse_by_fact_type[9], 5) +  "    |   30 to 40  |")	
    WriteLine(rpt, "    |-----------------------------------------------------------------|    ")
	WriteLine(rpt, "                                                            ")	

	
	rmse_vol_type = {{0, 4999}, {5000, 9999}, {10000, 19999}, {20000, 39999}, {40000, 59999}, {60000, 1000000}}
	rmse_numObs_vol_group = {0, 0, 0, 0, 0, 0}
	rmse_count_vol_group = {0, 0, 0, 0, 0, 0}
	rmse_by_vol_group = {0, 0, 0, 0, 0, 0}
	rmse_diff_vol_group = {0, 0, 0, 0, 0, 0}
	
	for i = 1 to vec_factype_cd.length do 
		if vec_daily_count[i] <> -1 then do
			for j = 1 to rmse_vol_type.length  do
				if vec_daily_count[i] >= rmse_vol_type[j][1] and vec_daily_count[i] <= rmse_vol_type[j][2] then do 

						rmse_count_vol_group[j] = rmse_count_vol_group[j] + vec_daily_count[i]
						rmse_diff_vol_group[j] = rmse_diff_vol_group[j]  + (vec_daily_flow[i] - vec_daily_count[i]) * (vec_daily_flow[i] - vec_daily_count[i])
						rmse_numObs_vol_group[j] = rmse_numObs_vol_group[j] + 1
				end
			end
		end
	end 
	
	for i = 1 to rmse_by_vol_group.length do
		rmse_by_vol_group[i] = "NA"
    end
	
	for i = 1 to rmse_by_vol_group.length do
		if rmse_numObs_vol_group[i] <> 0 then do
			rmse_by_vol_group[i] = sqrt( rmse_diff_vol_group[i] / rmse_numObs_vol_group[i]) / (rmse_count_vol_group[i] / rmse_numObs_vol_group[i]) * 100		
			rmse_by_vol_group[i] = i2s(r2i(Round(rmse_by_vol_group[i],0)))

		end
	end
		
	WriteLine(rpt, "")
	WriteLine(rpt, "    Percent Root Mean Square Error by Volume Group          ")
	WriteLine(rpt, "    |-----------------------------------------------------------------    ")
	WriteLine(rpt, "    |  Facility Type       | Observations |    Model    |    Target   |    ")
	WriteLine(rpt, "    |-----------------------------------------------------------------|    ")
	WriteLine(rpt, "    |  0 to 4,999          |   "+Lpad(i2s(rmse_numObs_vol_group[1]), 5) + "      |    "+Lpad(rmse_by_vol_group[1], 5) +  "    |     120     |")
	WriteLine(rpt, "    |  5,000 to 9,999      |   "+Lpad(i2s(rmse_numObs_vol_group[2]), 5) + "      |    "+Lpad(rmse_by_vol_group[2], 5) + "    |     45      |")
	WriteLine(rpt, "    |  10,000 to 19,999    |   "+Lpad(i2s(rmse_numObs_vol_group[3]), 5) + "      |    "+Lpad(rmse_by_vol_group[3], 5) +  "    |     40      |")
	WriteLine(rpt, "    |  20,000 to 39,999    |   "+Lpad(i2s(rmse_numObs_vol_group[4]), 5) + "      |    "+Lpad(rmse_by_vol_group[4], 5) + "    |     35      |")
	WriteLine(rpt, "    |  40,000 to 59,999    |   "+Lpad(i2s(rmse_numObs_vol_group[5]), 5) + "      |    "+Lpad(rmse_by_vol_group[5], 5) + "    |     30      |")
	WriteLine(rpt, "    |  60,000 and greater  |   "+Lpad(i2s(rmse_numObs_vol_group[6]), 5) + "      |    "+Lpad(rmse_by_vol_group[6], 5) +  "    |     20      |")
	WriteLine(rpt, "    |-----------------------------------------------------------------|    ")
	WriteLine(rpt, "")  
	
	CloseFile(rpt)
	RunMacro("close everything")
	Return(1)
			
endMacro


Macro "CreateZeroMatrix" (input_matrix, output_matrix)

	
	ifileName = input_matrix[1]
	iCoreName = input_matrix[3]
	oFileName   = output_matrix[1]
	oLablel     = output_matrix[2]
	oTable      = output_matrix[3]

	m = OpenMatrix(ifileName, )
	matrix_cores = GetMatrixCoreNames(m)
	mc1 = CreateMatrixCurrency(m,iCoreName,,, )


     CopyMatrixStructure({mc1,mc1}, {{"File Name", oFileName},
     {"Label", oLabel},
     {"File Based", "Yes"},
     {"Tables", {oTable}},
     {"Operation", "Union"}})

    m = OpenMatrix(oFileName, )	 
	mc1 = CreateMatrixCurrency(m, oTable, null, null, )	
	row_labels = GetMatrixRowLabels(mc1) 
	vals1 = GetMatrixValues(mc1, row_labels, row_labels)
		for i = 1 to vals1.length do
			for j = 1 to vals1[i].length do
				vals1[i][j] = 0.0
			end
		end
	
		SetMatrixValues(mc1, row_labels, row_labels, {"Copy", vals1}, null)
endMacro


Macro "AddCollapsedMatrix" (mat_file1, mat_file2)
// adds all the cores of the mat file 2 elemenet by element 
// and adds the result to mat_file1
	mat1 = OpenMatrix(mat_file1,)
	mat2 = OpenMatrix(mat_file2,)
	
	matrix_cores2 = GetMatrixCoreNames(mat2)
	matrix_cores1 = GetMatrixCoreNames(mat1)
	mc1 = CreateMatrixCurrency(mat1, matrix_cores1[1] , , , )
	row_labels = GetMatrixRowLabels(mc1)
	vals1 = GetMatrixValues(mc1, row_labels, row_labels)	
	

	for k = 1 to matrix_cores2.length do 
        
        mc2 = CreateMatrixCurrency(mat2, matrix_cores2[k] , , , )
		row_labels = GetMatrixRowLabels(mc2)
		vals2 = GetMatrixValues(mc2, row_labels, row_labels)
	
		for i = 1 to vals1.length do
			for j = 1 to vals1[i].length do
				if vals2[i][j] <> null then 
				     vals1[i][j] = vals1[i][j] + vals2[i][j]
			end
		end
	
		SetMatrixValues(mc1, row_labels, row_labels, {"Copy", vals1}, null)

	end 



endMacro

Macro "AddMatrices" (mat_file1, mat_file2)
	// adds the respective cores of the two matrix files 
//	mat1 = OpenMatrix(project_dir+ "\\interim\\OPVEH_TRIPS.mtx", )
//	mat2 = OpenMatrix(project_dir+ "\\interim\\OP2VEH_TRIPS.mtx", )
	
	mat1 = OpenMatrix(mat_file1,)
	mat2 = OpenMatrix(mat_file2,)
	
	matrix_cores2 = GetMatrixCoreNames(mat2)
	matrix_cores1 = GetMatrixCoreNames(mat1)
	for k = 1 to matrix_cores1.length do 
		mc1 = CreateMatrixCurrency(mat1, matrix_cores1[k] , , , )
		mc2 = CreateMatrixCurrency(mat2, matrix_cores2[k] , , , )
	// ShowArray(matrix_cores2)
	// ShowArray({mc2})
	
		row_labels = GetMatrixRowLabels(mc2)
		vals2 = GetMatrixValues(mc2, row_labels, row_labels)
		vals1 = GetMatrixValues(mc1, row_labels, row_labels)
	// ShowArray(vals1)
	// ShowArray(vals2)
	
		for i = 1 to vals1.length do
			for j = 1 to vals1[i].length do
				vals1[i][j] = vals1[i][j] + vals2[i][j]
			end
		end
	
		SetMatrixValues(mc1, row_labels, row_labels, {"Copy", vals1}, null)
	end 

endMacro


Macro "close everything"
    maps = GetMaps()
    if maps <> null then do
        for i = 1 to maps[1].length do
            SetMapSaveFlag(maps[1][i],"False")
            end
        end
    RunMacro("G30 File Close All")
    mtxs = GetMatrices()
    if mtxs <> null then do
        handles = mtxs[1]
        for i = 1 to handles.length do
            handles[i] = null
            end
        end
endMacro
