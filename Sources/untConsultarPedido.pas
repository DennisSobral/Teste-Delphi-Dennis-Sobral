unit untConsultarPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, PedidoController, pedidoCabecalhoVO,
  pedidoDetalheVO, generics.collections;

type
  TfrmConsultarPedido = class(TForm)
    edtCodigo: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure Confirmar;
  public
    { Public declarations }
     tipo: String;
  end;

var
  frmConsultarPedido: TfrmConsultarPedido;

implementation

{$R *.dfm}

uses untPrincipal;

procedure TfrmConsultarPedido.Confirmar;
Var cabecalho: TPedidoCabecalhoVO;
    detalhe: TObjectList<TPedidoDetalheVO>;
  I: Integer;
begin

   if Trim(edtCodigo.Text) <> '' then Begin

      if tipo = 'C' then
         TPedidoController.CancelarPedido(StrToInt(edtCodigo.Text))
      else Begin

         cabecalho := TPedidoController.RetornarPedidoCabecalhoPorID(strtoint(edtCodigo.Text));

         if cabecalho.numero > 0 then Begin

            frmPrincipal.LimparTela;
            frmprincipal.edtCodigoCliente.Text := cabecalho.id_cliente.ToString;

            detalhe := TPedidoController.RetornarPedidoDetalhePorID(cabecalho.numero);

            frmPrincipal.DAO := cabecalho.numero.ToString;

            for I := 0 to detalhe.Count - 1 do Begin

               frmPrincipal.FDDetalhe.Append;

               frmPrincipal.FDDetalheID.AsInteger           := detalhe.Items[i].id;
               frmPrincipal.FDDetalheid_produto.AsInteger   := detalhe.Items[i].id_produto;
               frmPrincipal.FDDetalhedescricao.AsString     := detalhe.Items[i].produtoVO.descricao;
               frmPrincipal.FDDetalhevalor_unitario.AsFloat := detalhe.Items[i].valor_unitario;
               frmPrincipal.FDDetalhequantidade.AsFloat     := detalhe.Items[i].quantidade;
               frmPrincipal.FDDetalhevalor_total.AsFloat    := detalhe.Items[i].valor_total;

               frmPrincipal.FDDetalhe.Post;

               frmPrincipal.lblTotal.Caption := FormatFloat('#0.00', StrToFloat(frmPrincipal.lblTotal.Caption)+detalhe.Items[i].valor_total);

            End;

            close;

         End else
            MessageDlg('Pedido não foi localizado na base de dados.',mtWarning ,[mbOK],0);



      End;

   End;


end;

procedure TfrmConsultarPedido.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin

   if  not ( Key in ['0'..'9', Chr(8)]) then
      Key := #0;

end;

procedure TfrmConsultarPedido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   case key of

      VK_ESCAPE: close;

   end;

end;

procedure TfrmConsultarPedido.SpeedButton1Click(Sender: TObject);
begin

   Confirmar;

end;

end.
