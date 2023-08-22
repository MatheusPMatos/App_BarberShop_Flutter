// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/icons/barberchop_icons.dart';
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';
import 'package:dw_barbershop/src/model/user_model.dart';

class HomeEmployeeTile extends StatelessWidget {
  final UserModel employee;
  const HomeEmployeeTile({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorsConstants.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: switch (employee.avatar) {
              final avatar? =>  NetworkImage(avatar),
              _ => const AssetImage(ImageConstants.avatar)
            } as ImageProvider)),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  employee.name,
                  style:const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12)),
                        onPressed: () { 
                          Navigator.of(context).pushNamed('/schedule', arguments: employee);
                        },
                        child: const Text('AGENDAR')),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12)),
                        onPressed: () {
                           Navigator.of(context).pushNamed('/employee/schedule', arguments: employee);
                        },
                        child: const Text('Ver Agenda')),
                    const Icon(
                      BarbershopIcons.penEdit,
                      size: 16,
                      color: ColorsConstants.brow,
                    ),
                    const Icon(
                      BarbershopIcons.trash,
                      size: 16,
                      color: ColorsConstants.brow,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
