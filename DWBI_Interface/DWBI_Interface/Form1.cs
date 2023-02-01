using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace DWBI_Interface
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        OracleConnection connection;
        private void Form1_Load(object sender, EventArgs e)
        {
            const string connectionString = @"DATA SOURCE=localhost:1521/ORCLPDB1;USER ID=DB;PASSWORD=ufbivgfbdDHASU832fjdl;";
            connection  = new OracleConnection(connectionString);
            connection.Open();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_LOCATION", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_tara", OracleDbType.Varchar2).Value = taraText.Text;
                command.Parameters.Add(@"valoare_oras", OracleDbType.Varchar2).Value = orasText.Text;
                command.Parameters.Add(@"valoare_strada", OracleDbType.Varchar2).Value = stradaText.Text;
                command.Parameters.Add(@"valoare_site", OracleDbType.Varchar2).Value = siteText.Text;
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = connection.CreateCommand();
                command.CommandText = "SELECT * FROM " + tabelText.Text;
                command.CommandType = CommandType.Text;
                OracleDataReader reader = command.ExecuteReader();
                reader.Read();
                if (!reader.HasRows) return;
                DataTable dataTable = new DataTable();
                dataTable.Load(reader);
                DataGridView dgv = dataview;
                dgv.DataSource = dataTable;
            }
            catch(Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_CARD", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_cod_cont", OracleDbType.Int64).Value = int.Parse(card_cod_cont.Text);
                command.Parameters.Add(@"valoare_tip_card", OracleDbType.Varchar2).Value = card_tip_card.Text;
                var data_emitere = card_data_emitere.Text.Split('.');
                command.Parameters.Add(@"valoare_data_emitere", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(data_emitere[2]), int.Parse(data_emitere[1]), int.Parse(data_emitere[0]));
                var data_expirare = card_data_expirare.Text.Split('.');
                command.Parameters.Add(@"valoare_data_expirare", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(data_expirare[2]), int.Parse(data_expirare[1]), int.Parse(data_expirare[0]));
                command.Parameters.Add(@"valoare_numar_card", OracleDbType.Varchar2).Value = card_numar_card.Text;
                command.ExecuteNonQuery();
            }
            catch(Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }
        private void label7_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_CONT", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_tip_cont", OracleDbType.Varchar2).Value = cont_tip_cont.Text;
                command.Parameters.Add(@"valoare_nume_cont", OracleDbType.Varchar2).Value = cont_nume_cont.Text;
                command.Parameters.Add(@"valoare_sold", OracleDbType.Int64).Value = int.Parse(cont_sold.Text);
                command.Parameters.Add(@"valoare_cod_client", OracleDbType.Int64).Value = int.Parse(cont_cod_client.Text);
                command.ExecuteNonQuery();
            }
            catch(Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_CANAL_PLATA", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_cod_comerciant", OracleDbType.Int64).Value = int.Parse(canal_plata_cod_comerciant.Text);
                command.Parameters.Add(@"valoare_cod_locatie", OracleDbType.Int64).Value = int.Parse(canal_plata_cod_locatie.Text);
                command.Parameters.Add(@"valoare_tip_echipament", OracleDbType.Varchar2).Value = canal_plata_tip_echipament.Text;
                command.Parameters.Add(@"valoare_cod_cont", OracleDbType.Int64).Value = int.Parse(canal_plata_cod_cont.Text);
                var data_inceput = canal_plata_data_inceput.Text.Split('.');
                command.Parameters.Add(@"valoare_data_inceput", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(data_inceput[2]), int.Parse(data_inceput[1]), int.Parse(data_inceput[0]));
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }

        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_COMERCIANT", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_cod_client", OracleDbType.Int64).Value = int.Parse(comerciantCodClient.Text);
                command.Parameters.Add(@"valoare_nume", OracleDbType.Varchar2).Value = comerciantNume.Text;
                var dataInscriere = comerciantDataInscriere.Text.Split('.');
                command.Parameters.Add(@"valoare_data_inscriere", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(dataInscriere[2]), int.Parse(dataInscriere[1]), int.Parse(dataInscriere[0]));
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }

        private void button7_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_CLIENT", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_nume", OracleDbType.Varchar2).Value = clientNume.Text;
                command.Parameters.Add(@"valoare_tip_client", OracleDbType.Varchar2).Value = clientTipClient.Text;
                var dataInscriere = clientDataInscriere.Text.Split('.');
                command.Parameters.Add(@"valoare_data_inscriere", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(dataInscriere[2]), int.Parse(dataInscriere[1]), int.Parse(dataInscriere[0]));
                var dataIncetare = clientDataIncetare.Text.Split('.');
                command.Parameters.Add(@"valoare_data_incetare", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(dataIncetare[2]), int.Parse(dataIncetare[1]), int.Parse(dataIncetare[0]));
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }

        private void button8_Click(object sender, EventArgs e)
        {
            exceptionsText.Text = string.Empty;
            try
            {
                OracleCommand command = new OracleCommand("ADD_TRANZACTIE", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(@"valoare_suma", OracleDbType.Int64).Value = int.Parse(tranzactieSuma.Text);
                command.Parameters.Add(@"valoare_cod_cont_debitor", OracleDbType.Int64).Value = int.Parse(tranzactieCodContDebitor.Text);
                command.Parameters.Add(@"valoare_cod_cont_creditor", OracleDbType.Int64).Value = int.Parse(tranzactieCodContCreditor.Text);
                var dataInitiere = tranzactieDataInitiere.Text.Split('.');
                command.Parameters.Add(@"valoare_data_initiere", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(dataInitiere[2]), int.Parse(dataInitiere[1]), int.Parse(dataInitiere[0]));
                var dataProcesare = tranzactieDataProcesare.Text.Split('.');
                command.Parameters.Add(@"valoare_data_procesare", OracleDbType.Date).Value = new OracleDate
                    (int.Parse(dataProcesare[2]), int.Parse(dataProcesare[1]), int.Parse(dataProcesare[0]));
                command.Parameters.Add(@"valoare_stare", OracleDbType.Varchar2).Value = tranzactieStare.Text;
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                exceptionsText.Text = ex.Message;
            }
        }
    }
}
