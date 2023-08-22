import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/auth/register/user/user_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVmProvider.notifier);
    ref.listen(
      userRegisterVmProvider,
      (_, state) {
        switch (state) {
          case UserRegisterStateStatus.initial:
          break;
          case UserRegisterStateStatus.sucess:
            Navigator.of(context).pushNamed('/auth/register/barbershop');
          case UserRegisterStateStatus.error:
            Messages.showError('Erro ao registrar usuário administrador', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nameEC,
                  validator: Validatorless.required("Nome obrigatório."),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório.'),
                    Validatorless.email('Digite um e_mail valido.')
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória.'),
                    Validatorless.min(6, 'Minimo de 6 caracteres')
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('Senha')),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  obscureText: true,
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirmar senha, obrigatória.'),
                    Validatorless.compare(
                        _passwordEC, 'Senha diferente de confirma senha')
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration:
                      const InputDecoration(label: Text('Confirmar Senha')),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56)),
                    onPressed: () {
                      switch (_formKey.currentState?.validate()) {
                        case null || false:
                          Messages.showError('Formulario inválido', context);
                        case true:
                          userRegisterVM.register(
                              name: _nameEC.text,
                              email: _emailEC.text,
                              password: _passwordEC.text);
                      }
                    },
                    child: const Text('CRIAR CONTA'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
