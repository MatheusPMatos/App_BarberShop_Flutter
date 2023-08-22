import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/icons/barberchop_icons.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  final bool showFilter;
  const HomeHeader({super.key}) : showFilter = true;
  const HomeHeader.withoutFilter({super.key}) : showFilter = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershop = ref.watch(getMyBarbershopProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        color: Colors.black,
        image: DecorationImage(
            image: AssetImage(
              ImageConstants.backgroundChair,
            ),
            fit: BoxFit.cover,
            opacity: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
               height: 24,
            ),
            barbershop.maybeWhen(
              orElse: () {
                return const Center(
                  child: BarbershopLoader(),
                );
              },
              data: (data) {
                return Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xffbdbdbd),
                      child: SizedBox.shrink(),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: Text(
                        data.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Expanded(
                      child: Text(
                        'Editar',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorsConstants.brow),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(homeAdmVmProvider.notifier).logout();
                      },
                      icon: const Icon(
                        BarbershopIcons.exit,
                        color: ColorsConstants.brow,
                        size: 32,
                      ),
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Bem Vindo',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Agende um Cliente',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Offstage(
              offstage: !showFilter,
              child: const SizedBox(
                height: 20,
              ),
            ),
            Offstage(
              offstage: !showFilter,
              child: TextFormField(
                decoration: const InputDecoration(
                    label: Text(
                      'Buscar Colaborador',
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: Icon(
                        BarbershopIcons.search,
                        color: ColorsConstants.brow,
                        size: 26,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
