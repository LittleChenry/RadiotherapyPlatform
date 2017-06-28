using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// equipment 的摘要说明
/// </summary>
public class equipment
{
    DataLayer sqlOperation = new DataLayer("sqlStr");
	public equipment()
	{
	}

    public DataSet Select(string state, string item)
    {
        string sqlCommand = "SELECT * FROM Equipment";
        string addString = "";
        if (state != "allEquipment")
        {
            int stateInt = int.Parse(state);
            addString += " WHERE State=@state";
            sqlOperation.AddParameterWithValue("@state", stateInt);
        }
        if (item != "allItem")
        {
            if (addString == "")
            {
                addString += " WHERE TreatmentItem=@item";
            }
            else
            {
                addString += " AND TreatmentItem=@item";
            }
            sqlOperation.AddParameterWithValue("@item", item);
        }

        DataSet myds = sqlOperation.ExecuteDataSet(sqlCommand + addString, "item");
        return myds;
    }

    public void Delete(string id)
    {
        string sqlCommand = "DELETE FROM Equipment WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}