﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using PagoAgil.Aplicacion.ViewModel;
using PagoAgil.Aplicacion.Modelo.ClienteSQL;
using PagoAgil.Aplicacion.BD.Utils;
using PagoAgil.Aplicacion.View.Pago.Excepciones;

namespace PagoAgil.Aplicacion.View.Pago
{
    public partial class FormSeleccionFacturas : Form
    {
        private PagoBuilder miPagoBuilder;
        private SeleccionFacturaVM VM;
        private decimal importeTotal;
        private int numeroFactura;
        private List<int> facturasPagadas = new List<int>();

        public FormSeleccionFacturas(PagoBuilder pagoBuilder)
        {
            InitializeComponent();
            this.CenterToScreen();

            VM = new SeleccionFacturaVM();
            miPagoBuilder = pagoBuilder;

            numericUpDownNroF.Text = "";

            EmpresaDB[] empresas = VM.obtenerEmpresas();

            comboBoxEmpresa.Items.AddRange(empresas);
        }

        private void buttonBuscarFactura_Click(object sender, EventArgs e)
        {
            numeroFactura = (int)numericUpDownNroF.Value;
            EmpresaDB empresaSeleccionada = comboBoxEmpresa.SelectedItem as EmpresaDB;
            DateTime fechaVencimiento = dateTimePickerFechaV.Value;

            try
            {
                DataTable factura = VM.buscarFactura(numeroFactura, empresaSeleccionada.id, fechaVencimiento);

                dataGridViewFacturas.DataSource = factura;

                dataGridViewFacturas.Columns[0].HeaderText = "Numero Factura";
                dataGridViewFacturas.Columns[1].HeaderText = "Monto Total";
                dataGridViewFacturas.Columns[2].HeaderText = "Fecha de Alta";
                dataGridViewFacturas.Columns[3].HeaderText = "Fecha de Vencimiento";
                dataGridViewFacturas.Columns[4].HeaderText = "Habilitada";
                dataGridViewFacturas.Columns[5].HeaderText = "Dni del Cliente";
                dataGridViewFacturas.Columns[6].HeaderText = "Id de Empresa";
                dataGridViewFacturas.Columns[7].HeaderText = "Numero de Rendicion";

                dataGridViewFacturas.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 1].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 2].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 3].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 4].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 5].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 6].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 7].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                dataGridViewFacturas.Columns[dataGridViewFacturas.ColumnCount - 8].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;

                decimal importeActual = factura.Rows[0].Field<decimal>(1);
                importeTotal += importeActual;
                labelImporteTotal.Text = importeTotal.ToString("N2");

                buttonConfirmarFactura.Enabled = true;
                buttonFinalizarPago.Enabled = false;
                buttonBuscarFactura.Enabled = false;
            }
            catch(FacturaInvalidaException)
            {
                MessageBox.Show("La factura buscada es incorrecta o ya fue pagada anteriormente");
                return;
            }
            
        }

        private void buttonConfirmarFactura_Click(object sender, EventArgs e)
        {
            facturasPagadas.Add(numeroFactura);

            numericUpDownNroF.Text = "";
            dateTimePickerFechaV.Value = DateTime.Now;
            comboBoxEmpresa.SelectedIndex = -1;
            dataGridViewFacturas.ClearSelection();

            buttonFinalizarPago.Enabled = true;
            buttonBuscarFactura.Enabled = true;
            buttonConfirmarFactura.Enabled = false;

        }

        private void buttonFinalizarPago_Click(object sender, EventArgs e)
        {
            miPagoBuilder.fechaPago = DateTime.Now;
            miPagoBuilder.montoTotal = importeTotal;

            VM.crearPago(miPagoBuilder.crearPago(), this.facturasPagadas);

            this.Hide();
        }
    }
}
