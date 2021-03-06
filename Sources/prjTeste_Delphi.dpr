program prjTeste_Delphi;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal},
  ClientesVO in '..\VO\ClientesVO.pas',
  ClientesController in '..\Controller\ClientesController.pas',
  ProdutosVO in '..\VO\ProdutosVO.pas',
  ProdutosController in '..\Controller\ProdutosController.pas',
  PedidoCabecalhoVO in '..\VO\PedidoCabecalhoVO.pas',
  PedidoDetalheVO in '..\VO\PedidoDetalheVO.pas',
  PedidoController in '..\Controller\PedidoController.pas',
  untConsultarPedido in 'untConsultarPedido.pas' {frmConsultarPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);

  Application.Run;
end.
