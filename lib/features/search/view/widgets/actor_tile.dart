import 'package:flutter/material.dart';

import '../../domain/entities/actor.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;
  final VoidCallback onTap;

  const ActorTile({super.key, required this.actor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF292736),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: const Color(0xFF3A3848),
              backgroundImage: actor.imageUrl.isNotEmpty
                  ? NetworkImage(actor.imageUrl)
                  : null,
              child: actor.imageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white54)
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                actor.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white30,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
