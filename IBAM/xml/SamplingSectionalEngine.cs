
namespace CORE.Engines 
{
	using System;
	using System.Collections;
	using System.IO;
	using System.Xml;
	
	[Serializable]
	public class SamplingSectionalEngine  : IEngine
	{
	
	
		public SamplingSectionalEngine(){}


		private int _oldpos;
		private int _pos;
		
		private string _msg= string.Empty;
		private string _parameters= string.Empty;
		
		private ArrayList _store;
		private Hashtable _sections;
		private Hashtable _scores;
		private Hashtable _criterias;
		private Hashtable _sectionCriterias;
		private Hashtable _gates;
		private Hashtable _storesection; 
		
		private string _form;
		
		private int RangeValue = 0;
		private string GroupID = string.Empty;
		private string TypeID = string.Empty;
		
		private void init()
		{
			_store = new ArrayList();  // selected items that will be administered;
			_sections= new Hashtable(); // second level of grouping terms used during the loading process;
			_scores= new Hashtable(); // item responses;
			_criterias = new Hashtable(); // master list of criterias used by the form;
			_sectionCriterias = new Hashtable(); // list of sections that are linked to a criteria;
			_gates = new Hashtable(); // end exam gates
			_storesection = new Hashtable(); // linking between store and section;
			
			_oldpos = -1;
			_pos = -1;
			_finished = false;
		}

		public void rollbackPosition(){
			_pos = _oldpos;
		}

		private void loadCriterias(XmlDocument FormParams){
		
			XmlNodeList thresholdList = FormParams.DocumentElement.SelectNodes("descendant::Threshold"); 
			for(int j = 0; j < thresholdList.Count; j++){
				string key = thresholdList[j].Attributes["ID"].Value;
				string value = thresholdList[j].Attributes["Value"].Value;
			
				_criterias[key] = new criteria( key, Int32.Parse(value) , 0) ;
			}
		
		}

		private void loadStoppingRule(string storeposition, string sectionposition, XmlDocument FormParams ){
		
			XmlNodeList bands = FormParams.GetElementsByTagName("Range");

			for(int j = 0; j < bands.Count; j++){

			int min = Int32.Parse(bands[j].Attributes["Min"].Value);
			int max = Int32.Parse(bands[j].Attributes["Max"].Value);

			if(RangeValue <= max && RangeValue >= min){
				XmlNode group = bands[j].SelectSingleNode("descendant::Group[@ID='" + GroupID + "']");
				
				XmlNode node = group.SelectSingleNode("descendant::Criteria[@Type='" + TypeID + "' and @Section='" + sectionposition + "']");
				
				if(node == null){
					return;
				}
				
				if(node.Attributes["Threshold"] == null ){
					return;
				}

				string Target = node.Attributes["Threshold"].Value;
				_sectionCriterias[storeposition] = Target;
				

				resetCriteriaValue((criteria)_criterias[Target], sectionposition, _scores);

				
			}

			}

		}
		
		private void selectSections(XmlDocument FormParams, int RangeValue, string GroupID, string TypeID){


			XmlNodeList bands = FormParams.GetElementsByTagName("Range");

			for(int j = 0; j < bands.Count; j++){

			int min = Int32.Parse(bands[j].Attributes["Min"].Value);
			int max = Int32.Parse(bands[j].Attributes["Max"].Value);

			if(RangeValue <= max && RangeValue >= min){
				XmlNode group = bands[j].SelectSingleNode("descendant::Group[@ID='" + GroupID + "']");
				addSections(group, TypeID );
				break;
			}

			}

		}
		
		private void addSections(XmlNode node, string type){

			XmlNodeList sections = node.SelectNodes("descendant::Criteria[@Type='" + type + "']");
			if(sections != null){
			for(int i=0; i < sections.Count; i++){
			_sections[sections[i].Attributes["Section"].Value] = sections[i].Attributes["Section"].Value;
			
			try{
			
			if( sections[i].Attributes["Gate"] != null){
				string sect = sections[i].Attributes["Section"].Value;
				if(!_gates.Contains( sect ) ){
					_gates[ sect ] = sections[i].Attributes["Gate"].Value ; 
				}
			}
			}catch(Exception ex){ _msg += ex.Message;}
			}
			}

		}


		public bool loadItems(XmlDocument doc, XmlDocument FormParams, bool WithHeader)
		{

			bool rtn = false;
			int Answered = 0;
			int currentSection = 0;
			int LastAnsweredSection = -1;//0;

			if(_store == null)
			{
					this.init();
					/* Load Items as strings in collection */

					doc.GetElementsByTagName("Form")[0].Attributes["Engine"].Value = "SamplingSectionalEngine";
					RangeValue = Int32.Parse(doc.GetElementsByTagName("Form")[0].Attributes["RangeValue"].Value);
					GroupID = doc.GetElementsByTagName("Form")[0].Attributes["GroupID"].Value;
					TypeID = doc.GetElementsByTagName("Form")[0].Attributes["TypeID"].Value;

					if(FormParams != null){
						selectSections(FormParams, RangeValue, GroupID, TypeID);
						loadCriterias(FormParams);
					}
					
					SortedList _hash = new SortedList();
					XmlNodeList items = doc.GetElementsByTagName("Item");


					for (int i=0; i< items.Count; i++)
					{
						int item_section = Int32.Parse(items[i].Attributes["Section"].Value);
						
						StringWriter sw = new StringWriter();
						XmlTextWriter xw = new XmlTextWriter(sw);

						if(items[i].Attributes["ID"].Value == string.Empty && !WithHeader)
						{
							continue;
						}

						if(!_sections.Contains(item_section.ToString()) )
						{
							continue;
						}
	
						if(items[i].Attributes["Response"].Value != String.Empty)
						{
							Answered += 1;
							_IsResume = true;
							
							// increment position if at least one item has been answered.
							if(currentSection != item_section){
								//_pos +=1;
								currentSection = item_section;
								LastAnsweredSection = currentSection;
							}

							recalculateScores (items[i]);

						}else{
							_IsCompleted = false;
						}

						items[i].Attributes["Position"].Value = (i + 1).ToString();
						items[i].WriteTo(xw);

						if (_hash.Contains(item_section))
						{
							_hash[item_section] =  (string)_hash[item_section] + sw.ToString();
						}
						else{
							_hash.Add(item_section, sw.ToString());
						}
					}
					foreach (DictionaryEntry myDE in _hash) {
						try{
						
						_storesection[ _store.Count.ToString()  ] = myDE.Key.ToString();
						
						if( LastAnsweredSection == Int32.Parse(myDE.Key.ToString()) ){
						
							_pos = _store.Count;// - 1;
						}
						
						loadStoppingRule(_store.Count.ToString(), myDE.Key.ToString(), FormParams);
						}catch(Exception ex){
							_msg = ex.Message;
						}

						_store.Add((string) myDE.Value);

					}

					/*   Store Document Shell */
					doc.GetElementsByTagName("Items")[0].RemoveAll();
					StringWriter sw2 = new StringWriter();
					XmlTextWriter xw2 = new XmlTextWriter(sw2);
					doc.WriteTo(xw2);
					_form = sw2.ToString();
					/*   Store Document Shell */

				rtn = true;

			}
			
			return rtn;
		}

  
		public string paramPROC{
			get{return "dbo.loadItemCriterias";}
		}

		private bool _IsResume = false;

		public bool IsResume
		{
			get{return _IsResume;}
		}

		private bool _IsCompleted = false;

		public bool IsCompleted
		{
			get{return _IsCompleted;}
		}

		private bool _finished = false;

		public int currentPosition
		{
			get{return _pos;}
			set{_pos = value;}
		}
		public int previousPosition
		{
			get{return _oldpos;}
			set{_oldpos = value;}
		}

		public bool finished
		{
			get{return _finished;}
			set { _finished = value; }
		}
		
		public int TotalItems
		{
			get{return _store.Count;}
		}
		public string message
		{
			get{return _msg;}
			set{_msg = value;}

		}
		public XmlDocument getNextItem()
		{		

			incrementPosition();
			
			while(!checkCriteria()){
                

				if(_finished ){
					break;
				}

				incrementPosition();
			}
			
			
			return getCurrentItem();

		}

		public XmlDocument getForm()
		{

			XmlDocument doc = new XmlDocument();
			doc.LoadXml(_form);

			// ***************** RELOAD THE DOCUMENT ********************** //
			XmlDocumentFragment docFrag = doc.CreateDocumentFragment();
			for (int i=0; i< _store.Count; i++) 
			{

				if(!_store.Contains(i)){
					continue;
				}

				docFrag.InnerXml = (String)_store[i];
				XmlNode deep = docFrag.CloneNode(true);
				doc.GetElementsByTagName("Items")[0].AppendChild(doc.ImportNode(deep,true));


			}

			return doc;

		}

        // Check to see whether there are enough items in the _storesection collection
        // and mark the engine as finished if there aren't enough items
		private bool checkCriteria(){

            bool rtn = true;

            if (_pos >= _storesection.Count)
            {
                _finished = true;
                rtn = false;
                return rtn;
            }

            string currentsection = _storesection[_pos.ToString()].ToString();
            if (_gates.Contains(currentsection))
            {
                criteria c = (criteria)_criterias[_gates[currentsection]];
                if (c.Threshold > c.Value)
                {
                    _finished = true;
                    rtn = false;
                    return rtn;
                }
            }

            if (!_sectionCriterias.Contains(_pos.ToString()))
            {
                return rtn;
            }
            else
            {
                string cID = (string)_sectionCriterias[_pos.ToString()];
                criteria c = (criteria)_criterias[cID];

                if (c.Value >= c.Threshold)
                {
                    rtn = false;
                }
            }           

			return rtn;
		}


		public XmlDocument getCurrentItem()
		{		
		
			XmlDocument doc = new XmlDocument();
			XmlDocumentFragment docFrag;
			if(!_finished)
			{
				doc.LoadXml(_form);

				if(_pos < _store.Count && _pos > -1)
				{
					
					// ***************** RELOAD THE DOCUMENT ********************** //
					docFrag = doc.CreateDocumentFragment();
					docFrag.InnerXml = (String)_store[_pos];
					XmlNode deep = docFrag.CloneNode(true);
					doc.GetElementsByTagName("Items")[0].AppendChild(doc.ImportNode(deep,true));
					
					_msg += "section " + (_pos + 1).ToString() + " of " + _store.Count.ToString(); // + ":: SequenceEngine";
				}
				else
				{
					// ***************** RELOAD THE DOCUMENT ********************** //
					docFrag = doc.CreateDocumentFragment();
					docFrag.InnerXml = (String)_store[_pos - 1];
					XmlNode deep = docFrag.CloneNode(true);
					doc.GetElementsByTagName("Items")[0].AppendChild(doc.ImportNode(deep,true));
					
					_msg += "section " + (_pos).ToString() + " of " + _store.Count.ToString(); // + ":: SequenceEngine";

					_finished = true;
					return doc;
	
				}
		
				
			}
			else
			{
				doc = null;
			}
				
			return doc;

		}
		
		private void setCriteriaValue(string section, Hashtable scores){
		    // loop through the items list and add up the Response attributes  

            try
            {
                int _sum = 0;
                string key = section;

                foreach (DictionaryEntry myDE in scores)
                {

                    XmlNode item = (XmlNode)myDE.Value;

                    if (item.Attributes["Section"].Value == section)
                    {
                        if (item.Attributes["Response"].Value.ToString().Length > 0)
                        {      
                            int intResponse = 0;
                            Int32.TryParse(item.Attributes["Response"].Value, out intResponse);
                            _sum += intResponse;                           
                        }
                    }
                }
                
				string cID = (string)_sectionCriterias[_pos.ToString()];
				criteria c = (criteria)_criterias[cID];
				if(_sum > c.Value){
					c.Value = _sum;
				}
				_criterias[cID] = c;
            }
            catch (Exception ex) { _msg += ex.Message; }
		}
		
		private void resetCriteriaValue(criteria c, string section, Hashtable scores){
		    // loop through the items list and add up the Response attributes  

            try
            {
                int _sum = 0;
                string key = section;

                foreach (DictionaryEntry myDE in scores)
                {

                    XmlNode item = (XmlNode)myDE.Value;

                    if (item.Attributes["Section"].Value == section)
                    {
                        if (item.Attributes["Response"].Value.ToString().Length > 0)
                        {      
                            int intResponse = 0;
                            Int32.TryParse(item.Attributes["Response"].Value, out intResponse);
                            _sum += intResponse;                           
                        }
                    }
                }
                
				if(_sum > c.Value){
				c.Value = _sum;
				}

				_criterias[c.ID] = c;
            }
            catch (Exception ex) { _msg += ex.Message; }
		}

        public void recalculateScores (XmlNode node){

            try
            {
                if (_scores.Contains(node.Attributes["FormItemOID"].Value))
                {
                    _scores[node.Attributes["FormItemOID"].Value] = node;                   
                }
                else
                {
                    _scores.Add(node.Attributes["FormItemOID"].Value, node);                  
                }
            }
            catch (Exception ex) {
                _msg += ex.Message;
            
            }
        
        }

		public void updateNode(XmlNode node)
		{

			if (_sectionCriterias.Contains(_pos.ToString()))
            {
                recalculateScores(node);               
                setCriteriaValue(node.Attributes["Section"].Value, _scores);
            }


			for (int i=0; i <_store.Count; i++)
			{
				XmlDocument doc = new XmlDocument();
				doc.LoadXml(_form);
				XmlDocumentFragment docFrag = doc.CreateDocumentFragment();
				docFrag.InnerXml = (String)_store[i];
				XmlNode deep = docFrag.CloneNode(true);
				doc.GetElementsByTagName("Items")[0].AppendChild(doc.ImportNode(deep,true));
			
				XmlNodeList list = doc.GetElementsByTagName("Items")[0].SelectNodes("descendant::Item[@FormItemOID ='" + node.Attributes["FormItemOID"].Value + "']");

				if(list.Count == 1)
				{

				doc.GetElementsByTagName("Items")[0].ReplaceChild(doc.ImportNode(node,true), list[0]);
				XmlNodeList items = doc.GetElementsByTagName("Item");

				string newFragment = string.Empty;
				for (int l=0; l< items.Count; l++)
				{

					StringWriter sw = new StringWriter();
					XmlTextWriter xw = new XmlTextWriter(sw);
					items[l].WriteTo(xw);
					newFragment += sw.ToString();
				}

				_store[i] = newFragment;
				break;

				}

			}

		}

		public XmlDocument getPreviousItem()
		{
			decrementPosition();
			
			while(!checkCriteria()){
			
			if( _gates.Contains( _storesection[ _pos.ToString()].ToString() ) ){
				break;
			}
			
				if(_pos == 0){
					_finished = true;
					break;
				}

				decrementPosition();
			}
			
			return getCurrentItem();
		}
		
		public void decrementPosition(){
		
			if(_pos == -1){
				_oldpos = _pos;
				_pos = 0;
				
			}
			if(_pos > 0){
				_oldpos = _pos;
				_pos -= 1;
			}
		
		}
		public void incrementPosition()
		{
			if(_pos  == _store.Count)
			{
				_finished = true;
			}
			if(_pos < _store.Count)
			{
				_oldpos = _pos;
				_pos += 1;
			}	
		}
		
		
		[Serializable]
		private struct criteria{

			public string ID;
			public int Threshold;
			public int Value;

			public criteria( string _ID, int _Threshold, int _Value )
			{
				ID = _ID;
				Threshold = _Threshold;
				Value = _Value;
			}
		}
		
	} // END Concrete Class

} 