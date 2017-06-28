using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;

/* ***********************************************************
 * FileName: DataLayer.cs
 * Writer: peach
 * create Date: 2017-3-28
 * ReWriter:
 * Rewrite Date:
 * impact :
 * **********************************************************/

#region//数据层,需在网站添加引用中加入Mysql.Data引用;在web.config中加入数据库字符串
/// <summary>
/// DataLayer用来实现对数据层的各种操作
/// </summary>
public class DataLayer
{
    private MySqlConnection _sqlConnect;//Mysql连接对象
    private MySqlCommand _sqlCommand;//Mysql命令对象
    private string _strConnectString;//连接字符串

    #region//构造函数
    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="strConnectionName">web.config中的连接数据库字段引用名</param>
    public DataLayer(string strConnectionName)
	{
        _strConnectString = System.Configuration.ConfigurationManager.ConnectionStrings[strConnectionName].ToString();
        _sqlConnect = new MySqlConnection(_strConnectString);
        _sqlCommand = new MySqlCommand("", _sqlConnect);
    }
    #endregion

    #region//打开数据库连接
    /// <summary>
    /// 打开数据库连接
    /// </summary>
    public void Open()
    {
        if (_sqlConnect == null)
        {
            _sqlConnect = new MySqlConnection(_strConnectString);
        }
        if (_sqlConnect.State == System.Data.ConnectionState.Closed)
        {
            _sqlConnect.Open();
        }
    }
    #endregion

    #region//关闭数据库连接
    /// <summary>
    /// 关闭数据库连接
    /// </summary>
    public void Close()
    {
        if (_sqlConnect != null)
            _sqlConnect.Close();
    }
    #endregion

    #region//释放数据库连接资源
    /// <summary>
    /// 释放数据库连接资源
    /// </summary>
    public void Dispose()
    {
        if (_sqlConnect != null)
        {
            _sqlConnect.Dispose();
            _sqlConnect = null;
        }
    }
    #endregion

    #region//给MySqlCommand传入参数
    /// <summary>
    /// 给MySqlCommand传入参数
    /// </summary>
    /// <param name="strParamName">参数存储过程名称</param>
    /// <param name="objValue">参数实际对象值</param>
    public void AddParameterWithValue(string strParamName, object objValue)
    {
        if (GetParameter(strParamName) != null)//这个参数存在时
        {
            changeParameterValue(GetParameter(strParamName), objValue);
        }
        else
        {
            _sqlCommand.Parameters.AddWithValue(strParamName, objValue);
        }
    }
    #endregion

    #region//给MySqlCommand传入参数
    /// <summary>
    /// 给MySqlCommand传入参数
    /// </summary>
    /// <param name="strParamName">参数存储过程名称</param>
    /// <param name="dataType">参数类型(MySqlDbType.xxx)</param>
    /// <param name="size">参数值最大长度</param>
    /// <param name="value">参数实际对象值</param>
    public void AddParameter(string strParamName,MySqlDbType dataType, int size, object objValue)
    {
        _sqlCommand.Parameters.Add(strParamName, dataType, size).Value = objValue;
    }

    /// <summary>
    /// 给MySqlCommand传入参数
    /// </summary>
    /// <param name="sqlParameter">参数对象</param>
    public void AddParameter(MySqlParameter sqlParameter)
    {
        _sqlCommand.Parameters.Add(sqlParameter);
    }
    #endregion

    #region//获取MysqlCommand对象的参数
    /// <summary>
    /// 获取MysqlCommand对象的参数
    /// </summary>
    /// <param name="index">参数下标</param>
    /// <returns></returns>
    public MySqlParameter GetParameter(int index)
    {
        if (index < _sqlCommand.Parameters.Count)
        {
            return _sqlCommand.Parameters[index];
        }
        else
            throw new Exception("范围越界");
    }

    /// <summary>
    /// 获取MysqlCommand对象的参数
    /// </summary>
    /// <param name="strParamName">参数名</param>
    /// <returns></returns>
    public MySqlParameter GetParameter(string strParamName)
    {
        try{
            return _sqlCommand.Parameters[strParamName];
        }
        catch(Exception ex){
            return null;
        }
    }
    #endregion

    #region//传入参数生成一个MySQLParameter
    /// <summary>
    /// 传入参数生成一个MySQLParameter
    /// </summary>
    /// <param name="strParamName">存储过程名称</param>
    /// <param name="dataType">参数类型</param>
    /// <param name="size">参数大小</param>
    /// <param name="objValue">参数值</param>
    /// <param name="direction">参数方向</param>
    /// <returns>新的MySQLParameter对象</returns>
    public MySqlParameter CreateParameter(string strParamName, MySqlDbType dataType, int size, System.Data.ParameterDirection direction, object objValue)
    {
        MySqlParameter sqlParameter;
        if (size > 0)
        {
            sqlParameter = new MySqlParameter(strParamName, dataType, size);
        }
        else
        {
            sqlParameter = new MySqlParameter(strParamName, dataType);
        }
        sqlParameter.Direction = direction;
        if (objValue != null && sqlParameter.Direction != System.Data.ParameterDirection.Output)
        {
            sqlParameter.Value = objValue;
        }
        return sqlParameter;
    }
    #endregion

    #region//改变参数值
    /// <summary>
    /// 改变参数值
    /// </summary>
    /// <param name="sqlParameter">参数对象</param>
    /// <param name="objValue">参数值</param>
    public void changeParameterValue(MySqlParameter sqlParameter, object objValue)
    {
        if (sqlParameter.Direction != System.Data.ParameterDirection.Output)
            sqlParameter.Value = objValue;
    }
    #endregion

    #region//清空MySqlCommand对象参数
    /// <summary>
    /// 清空MySqlCommand对象参数
    /// </summary>
    public void clearParameter()
    {
        _sqlCommand.Parameters.Clear();
    }
    #endregion

    #region//执行SQL语句返回影响行数
    /// <summary>
    /// 执行SQL语句,返回影响行数
    /// </summary>
    /// <param name="strMysqlCommandString">SQL命令语句</param>
    /// <returns>SQL语句影响行数</returns>
    public int ExecuteNonQuery(string strMysqlCommandString)
    {
        this.Open();
        _sqlCommand.CommandText = strMysqlCommandString;
        if (_sqlCommand.Connection == null)
        {
            _sqlCommand.Connection = _sqlConnect;
        }
        int intResult = _sqlCommand.ExecuteNonQuery();
        this.Close();
        return intResult;
    }
    #endregion

    #region//执行SQL语句返回第一个匹配结果
    /// <summary>
    /// 执行SQL语句返回第一个匹配结果
    /// </summary>
    /// <param name="strMysqlCommandString">SQL语句</param>
    /// <returns>第一个匹配结果</returns>
    public string ExecuteScalar(string strMysqlCommandString)
    {
        this.Open();
        _sqlCommand.CommandText = strMysqlCommandString;
        if (_sqlCommand.Connection == null)
        {
            _sqlCommand.Connection = _sqlConnect;
        }
        string strResult = _sqlCommand.ExecuteScalar().ToString();
        this.Close();
        return strResult;
    }
    #endregion

    #region//执行语句,返回MySqlDataReader
    /// <summary>
    /// 执行语句,所有匹配结果存在MysqlDataReader对象中,返回该对象.!Reader必须关闭才能进行其他语句执行
    /// </summary>
    /// <param name="strMysqlCommandString">SQL语句</param>
    /// <returns></returns>
    public MySqlDataReader ExecuteReader(string strMysqlCommandString)
    {
        this.Open();
        _sqlCommand.CommandText = strMysqlCommandString;
        if (_sqlCommand.Connection == null)
        {
            _sqlCommand.Connection = _sqlConnect;
        }
        MySqlDataReader sqlReader;
        sqlReader = _sqlCommand.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        return sqlReader;//关闭连接会导致reader关闭
    }
    #endregion

    #region//执行SQL语句返回DataSet
    /// <summary>
    /// 执行SQL查询语句，返回DataSet数据集
    /// </summary>
    /// <param name="strMysqlCommandString">SQL查询语句</param>
    /// <param name="strSrcTable">用于表映射的源表名称</param>
    /// <returns></returns>
    public System.Data.DataSet ExecuteDataSet(string strMysqlCommandString, string strSrcTable)
    {
        this.Open();
        _sqlCommand.CommandText = strMysqlCommandString;
        if (_sqlCommand.Connection == null)
        {
            _sqlCommand.Connection = _sqlConnect;
        }
        MySqlDataAdapter sqlDataAdapter = new MySqlDataAdapter(_sqlCommand);
        System.Data.DataSet myds = new System.Data.DataSet();
        sqlDataAdapter.Fill(myds, strSrcTable);
        return myds;
    }
    #endregion

    #region//执行SQL查询语句,返回数据表
    /// <summary>
    /// 执行SQL查询语句,返回数据表
    /// </summary>
    /// <param name="strMysqlCommandString">SQL查询语句</param>
    /// <returns></returns>
    public System.Data.DataTable ExecuteDataTable(string strMysqlCommandString)
    {
        this.Open();
        _sqlCommand.CommandText = strMysqlCommandString;
        if (_sqlCommand.Connection == null)
        {
            _sqlCommand.Connection = _sqlConnect;
        }
        MySqlDataAdapter sqlDataAdapter = new MySqlDataAdapter(_sqlCommand);
        System.Data.DataTable mydt = new System.Data.DataTable();
        sqlDataAdapter.Fill(mydt);
        return mydt;
    }
    #endregion
}
#endregion