import 'package:flutter/material.dart';

class Mensagem extends StatelessWidget {
  final String conteudoMensagem;
  final String nomeUsuario;
  final String dataHora;
  final bool isMe;
  final VoidCallback? onExcluir;
  final Function(String)? onEditar;
  final bool editada;

  const Mensagem({
    super.key,
    required this.conteudoMensagem,
    required this.nomeUsuario,
    required this.dataHora,
    required this.isMe,
    this.onExcluir,
    this.onEditar,
    this.editada = false,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;
    const textoStyle = TextStyle(color: Colors.black87);

    return Row(
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe) // Espaço vazio do lado oposto ao texto, se a mensagem não for minha
          const SizedBox(width: 50),
        Flexible(
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  nomeUsuario,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  if (isMe) {
                    _showContextMenu(context, details.globalPosition);
                  }
                },
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.green[100] : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: isMe ? const Radius.circular(8) : const Radius.circular(0),
                      topRight:
                          isMe ? const Radius.circular(0) : const Radius.circular(8),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        conteudoMensagem,
                        style: textoStyle,
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            dataHora,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          if (editada)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                '(Editada)',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isMe) // Espaço vazio do lado oposto ao texto, se a mensagem for minha
          const SizedBox(width: 50),
      ],
    );
  }

  void _showContextMenu(BuildContext context, Offset tapPosition) {
    final RelativeRect positionPopup = RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      tapPosition.dx,
      tapPosition.dy,
    );

    showMenu(
      context: context,
      position: positionPopup,
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'editar',
          child: Text('Editar'),
        ),
        const PopupMenuItem(
          value: 'excluir',
          child: Text('Excluir'),
        ),
      ],
    ).then((value) {
      if (value == 'editar') {
        _editarMensagem(context);
      } else if (value == 'excluir') {
        if (onExcluir != null) {
          onExcluir!();
        }
      }
    });
  }

  void _editarMensagem(BuildContext context) {
    if (!isMe) return; // Não permite editar se não for a mensagem do usuário

    final TextEditingController _controller = TextEditingController();
    _controller.text = conteudoMensagem;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Mensagem'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Digite sua mensagem...'),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF4B9460)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (onEditar != null) {
                onEditar!(_controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Salvar',
              style: TextStyle(color: Color(0xFF4B9460)),
            ),
          ),
        ],
      ),
    );
  }
}
