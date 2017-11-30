using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dicom;
using System.Text;


/// <summary>
/// Dcm 的摘要说明
/// </summary>
public class Dcm
{
	public Dcm()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public static string get(System.IO.Stream file)
    {
        StringBuilder result = new StringBuilder("{\"information\":[");

        DicomFile dcmFile = DicomFile.Open(file);
        DicomDataset dcmDataSet = dcmFile.Dataset;

        String patientName = dcmDataSet.Get<String>(DicomTag.PatientName);
        String patientID = dcmDataSet.Get<String>(DicomTag.PatientID);
        String patientSex = dcmDataSet.Get<String>(DicomTag.PatientSex);

        String tps = dcmDataSet.Get<String>(DicomTag.ManufacturerModelName);

        //摆位信息
        DicomSequence patientSetupSequence = dcmDataSet.Get<DicomSequence>(DicomTag.PatientSetupSequence);
        IList<DicomDataset> patientSetupSequence_list = patientSetupSequence.Items;
        DicomDataset patientSetupSequence_list_d0 = patientSetupSequence_list.ElementAt(0);
        String postion = patientSetupSequence_list_d0.Get<String>(DicomTag.PatientPosition);

        result.Append("{\"id\":\"").Append(patientID).Append("\"")
              .Append(",\"lastName\":\"").Append(patientName.Split('^')[0]).Append("\"")
              .Append(",\"firstName\":\"").Append(patientName.Split('^')[1]).Append("\"")
              .Append(",\"tps\":\"").Append(tps).Append("\"");

        //Mu,射野总数
        DicomDataset fractionGroupSequence = dcmDataSet.Get<DicomSequence>(DicomTag.FractionGroupSequence).Items[0];
        String all = fractionGroupSequence.Get<String>(DicomTag.NumberOfBeams);//射野总数

        result.Append(",\"all\":\"").Append(all).Append("\"")
              .Append(",\"once\":\"").Append("").Append("\"")
              .Append(",\"fieldTimes\":\"").Append("").Append("\"")
              .Append(",\"pos\":\"").Append(postion).Append("\"}")
              .Append("],\"details\":[");
        //含有Mu
        IList<DicomDataset> referencedBeamSequence_list = fractionGroupSequence.Get<DicomSequence>(DicomTag.ReferencedBeamSequence).Items;
        int i = 0;
        //射野信息
        DicomSequence beamSequence = dcmDataSet.Get<DicomSequence>(DicomTag.BeamSequence);
        IList<DicomDataset> beamSequence_list = beamSequence.Items;
        foreach(DicomDataset d in beamSequence_list){
            String a1 = d.Get<String>(DicomTag.BeamName);//射野ID
            String technology = d.Get<String>(DicomTag.BeamType);//照射技术
            String equipment = d.Get<String>(DicomTag.TreatmentMachineName);//放疗设备
            String child = d.Get<String>(DicomTag.NumberOfControlPoints);//子野数
            String mu = referencedBeamSequence_list.ElementAt(i++).Get<String>(DicomTag.BeamMeterset);

            //3个角
            DicomDataset three = d.Get<DicomSequence>(DicomTag.ControlPointSequence).Items.ElementAt(0);
            String jjj = three.Get<String>(DicomTag.GantryAngle);
            String jtj = three.Get<String>(DicomTag.BeamLimitingDeviceAngle);
            String czj = three.Get<String>(DicomTag.TableTopEccentricAngle);

            result.Append("{\"a1\":\"").Append(a1).Append("\"")
                  .Append(",\"mu\":\"").Append(mu).Append("\"")
                  .Append(",\"equipment\":\"").Append(equipment).Append("\"")
                  .Append(",\"technology\":\"").Append(technology).Append("\"")
                  .Append(",\"type\":\"").Append("").Append("\"")
                  .Append(",\"energyField\":\"").Append("").Append("\"")
                  .Append(",\"ypj\":\"").Append("").Append("\"")
                  .Append(",\"jjj\":\"").Append(jjj).Append("\"")
                  .Append(",\"jtj\":\"").Append(jtj).Append("\"")
                  .Append(",\"czj\":\"").Append(czj).Append("\"")
                  .Append(",\"childs\":\"").Append(child).Append("\"},");;
        }

        return result.ToString();
    }
}