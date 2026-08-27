Set<String> toggleTagInSet(Set<String> tags, String tag) {
  return tags.contains(tag)
      ? tags.where((t) => t != tag).toSet()
      : {...tags, tag};
}
