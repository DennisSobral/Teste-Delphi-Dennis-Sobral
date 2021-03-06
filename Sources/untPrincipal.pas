unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.StdCtrls, produtosVO,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, clientesVO, clientesController,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, produtosController,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, pedidoDetalheVO,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, pedidoCabecalhoVO, pedidoController,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, generics.collections;

type
  TfrmPrincipal = class(TForm)
    DBGrid1: TDBGrid;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    edtValor: TEdit;
    edtTotal: TEdit;
    spbInserir: TSpeedButton;
    edtCodigoCliente: TEdit;
    edtDadosCliente: TEdit;
    Conexao: TFDConnection;
    MySQL: TFDPhysMySQLDriverLink;
    edtQuantidade: TEdit;
    FDDetalhe: TFDMemTable;
    FDDetalheid_produto: TIntegerField;
    FDDetalhedescricao: TStringField;
    FDDetalhevalor_unitario: TFloatField;
    FDDetalhequantidade: TFloatField;
    FDDetalhevalor_total: TFloatField;
    dtsDetalhe: TDataSource;
    lblTotal: TLabel;
    SpeedButton2: TSpeedButton;
    spbPesquisar: TSpeedButton;
    spbExcluir: TSpeedButton;
    spbLimpar: TSpeedButton;
    FDDetalheID: TIntegerField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoChange(Sender: TObject);
    procedure edtValorChange(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure spbInserirClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure spbPesquisarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbLimparClick(Sender: TObject);
  private
    { Private declarations }
    Var valorTotalEditando: double;
    Procedure RetornarClientePorID;
    Procedure RetornarProdutoPorID;
    procedure AlterarProduto;
    procedure Totalizar;
    procedure Confirmar;
    procedure Excluir;
    procedure GravarPedido;
  public
    { Public declarations }
    DAO: String;
    procedure LimparTela;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses untConsultarPedido;

procedure TfrmPrincipal.AlterarProduto;
begin

   if FDDetalhe.IsEmpty then Begin

      MessageDlg('Selecione um produto.', mtWarning, [mbOK],0);
      Exit;

   End;

   edtCodigo.Text     := FDDetalheid_produto.AsString;
   edtDescricao.Text  := FDDetalhedescricao.AsString;
   edtValor.Text      := FDDetalhevalor_unitario.AsString;
   edtQuantidade.Text := FDDetalhequantidade.AsString;

   edtCodigo.Enabled  := False;

   valorTotalEditando := FDDetalhevalor_total.AsFloat;

   edtQuantidade.SetFocus;

   FDDetalhe.Edit;

end;

procedure TfrmPrincipal.Confirmar;
begin

   if Trim(edtDescricao.Text) = '' then Begin

      MessageDlg('Informe um produto.', mtWarning, [mbOK],0);
      edtCodigo.SetFocus;
      Exit;

   End;

   if Trim(edtQuantidade.Text) = '' then Begin

      MessageDlg('Informe a quantidade do produto.', mtWarning, [mbOK],0);
      edtQuantidade.SetFocus;
      Exit;

   End;

   if StrToFloat(edtTotal.Text) <= 0 then Begin

      MessageDlg('Valor total inv?lido.', mtWarning, [mbOK],0);
      edtCodigo.SetFocus;
      Exit;

   End;

   if Not(FDDetalhe.State = dsEdit) then
      FDDetalhe.Append
   else
      lblTotal.Caption := FormatFloat('#0.00', StrToFloat(lblTotal.Caption)-valorTotalEditando);

   FDDetalheid_produto.AsInteger   := StrToInt(edtCodigo.Text);
   FDDetalhedescricao.AsString     := Trim(edtDescricao.Text);
   FDDetalhevalor_unitario.AsFloat := StrToFloat(edtValor.Text);
   FDDetalhequantidade.AsFloat     := StrToFloat(edtQuantidade.Text);
   FDDetalhevalor_total.AsFloat    := StrToFloat(edtTotal.Text);

   FDDetalhe.Post;
   FDDetalhe.First;

   lblTotal.Caption := FormatFloat('#0.00', StrToFloat(lblTotal.Caption)+StrToFloat(edtTotal.Text));

   edtCodigo.Text     := '';
   edtQuantidade.Text := '1,00';
   edtTotal.Text      := '0,00';
   edtCodigo.Enabled  := True;

   edtCodigo.SetFocus;

end;

procedure TfrmPrincipal.DBGrid1DblClick(Sender: TObject);
begin

   AlterarProduto;

end;

procedure TfrmPrincipal.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   if key = VK_DELETE then
      Excluir;

end;

procedure TfrmPrincipal.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin

   if Key = #13 then
      AlterarProduto;

end;

procedure TfrmPrincipal.edtCodigoChange(Sender: TObject);
begin

   RetornarProdutoPorID;

end;

procedure TfrmPrincipal.edtCodigoClienteChange(Sender: TObject);
begin

   RetornarClientePorID;

end;

procedure TfrmPrincipal.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin

   if  not ( Key in ['0'..'9', Chr(8)]) then
      Key := #0;

end;

procedure TfrmPrincipal.edtQuantidadeChange(Sender: TObject);
begin

   Totalizar;

end;

procedure TfrmPrincipal.edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin

   if  not ( Key in ['0'..'9', Chr(8), FormatSettings.DecimalSeparator] ) then
      Key := #0;

end;

procedure TfrmPrincipal.edtValorChange(Sender: TObject);
begin

   Totalizar;

end;

procedure TfrmPrincipal.Excluir;
begin

   if FDDetalhe.IsEmpty then Begin

      MessageDlg('Selecione um produto.', mtWarning, [mbOK],0);
      Exit;

   End;

   if MessageDlg('Confirma a esclus?o do registro?', mtConfirmation,[mbYes, mbNo], 0) = mrYes then Begin

      lblTotal.Caption := FormatFloat('#0.00', StrToFloat(lblTotal.Caption)-FDDetalhevalor_total.AsFloat);

      if FDDetalheID.AsInteger > 0 then
         TPedidoController.CancelarItem(FDDetalheID.AsInteger);

      FDDetalhe.Delete;


   End;


end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

   MySQL.VendorLib := (ExtractFilePath(Application.ExeName)+'libmysql.dll');

   FDDetalhe.Close;
   FDDetalhe.Open;

end;

procedure TfrmPrincipal.GravarPedido;
Var cabecalho: TPedidoCabecalhoVO;
    detalhe: TPedidoDetalheVO;
    listaDetalhe: TObjectList<TPedidoDetalheVO>;
begin

   if FDDetalhe.IsEmpty then Begin

      MessageDlg('Pedido sem produtos inseridos.', mtWarning, [mbOK],0);
      edtCodigo.SetFocus;
      Exit;

   End;

   cabecalho    := TPedidoCabecalhoVO.Create;
   listaDetalhe := TObjectList<TPedidoDetalheVO>.Create;

   cabecalho.valor_total := StrToFloat(lblTotal.Caption);
   cabecalho.id_cliente  := StrToInt(edtCodigoCliente.Text);

   FDDetalhe.First;

   while Not(FDDetalhe.Eof) do Begin

      if Not(FDDetalheID.AsInteger > 0) then Begin

         detalhe := TPedidoDetalheVO.Create;

         detalhe.id_produto     := FDDetalheid_produto.AsInteger;
         detalhe.quantidade     := FDDetalhequantidade.AsFloat;
         detalhe.valor_unitario := FDDetalhevalor_unitario.AsFloat;
         detalhe.valor_total    := FDDetalhevalor_total.AsFloat;

         listaDetalhe.Add(detalhe);

      End;

      FDDetalhe.Next;

   End;

   if DAO <> '' then
      cabecalho.numero := StrToInt(DAO);

   TPedidoController.GravarPedido(cabecalho, listaDetalhe);

end;

procedure TfrmPrincipal.LimparTela;
begin

   edtCodigoCliente.Text := '';
   edtDadosCliente.Text  := '';
   edtCodigo.Text        := '';
   edtDescricao.Text     := '';
   edtValor.Text         := '';
   edtQuantidade.Text    := '';
   edtTotal.Text         := '';
   DAO := '';
   lblTotal.Caption      := '0,00';

   FDDetalhe.Close;
   FDDetalhe.Open;

end;

procedure TfrmPrincipal.RetornarClientePorID;
Var cliente: TClientesVO;
begin

  edtDadosCliente.Text  := '';
  spbPesquisar.Enabled := True;
  spbExcluir.Enabled   := True;
  spbInserir.Enabled   := False;

   if Trim(edtCodigoCliente.Text) <> '' then Begin

      cliente := TClientesController.RetornarClientePorID(StrToInt(edtCodigoCliente.Text));

      if cliente.codigo > 0 then Begin
         spbPesquisar.Enabled := False;
         spbExcluir.Enabled   := False;
         spbInserir.Enabled   := True;
         edtCodigoCliente.Text := cliente.codigo.ToString;
         edtDadosCliente.Text  := cliente.nome+' ('+cliente.cidade+'/'+cliente.uf+')';
      End;

   End;

end;

procedure TfrmPrincipal.RetornarProdutoPorID;
Var produto: TProdutosVO;
begin

   edtDescricao.Text := '';
   edtValor.Text     := '';

   if Trim(edtCodigo.Text) <> '' then Begin

      produto := TProdutosController.RetornarProdutoPorID(StrToInt(edtCodigo.Text));

      if produto.codigo > 0 then Begin

         edtDescricao.Text := Trim(produto.descricao);
         edtValor.Text     := FormatFloat('#0.00', produto.preco_venda);
         Totalizar;

      End;

   End;

end;

procedure TfrmPrincipal.spbInserirClick(Sender: TObject);
begin

   Confirmar;

end;

procedure TfrmPrincipal.SpeedButton2Click(Sender: TObject);
begin

   GravarPedido;

end;

procedure TfrmPrincipal.spbPesquisarClick(Sender: TObject);
begin

   Application.CreateForm(TfrmConsultarPedido, frmConsultarPedido);
   frmConsultarPedido.Caption := 'Pesquisar';
   frmConsultarPedido.tipo := 'P';
   frmConsultarPedido.ShowModal;

end;

procedure TfrmPrincipal.spbExcluirClick(Sender: TObject);
begin

   Application.CreateForm(TfrmConsultarPedido, frmConsultarPedido);
   frmConsultarPedido.Caption := 'Cancelar';
   frmConsultarPedido.tipo := 'C';
   frmConsultarPedido.ShowModal;

end;

procedure TfrmPrincipal.spbLimparClick(Sender: TObject);
begin

   LimparTela;

end;

procedure TfrmPrincipal.Totalizar;
Var unitario, quantidade: double;
begin

   if edtValor.Text <> '' then
      unitario := StrToFloat(edtValor.Text);

   if edtQuantidade.Text <> '' then
      quantidade := StrToFloat(edtQuantidade.Text);

   edtTotal.Text := FormatFloat('#0.00', unitario * quantidade);


end;

end.
